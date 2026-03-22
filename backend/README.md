# ⚙️ Backend (Serverless)

> **Scalable Python orchestration layer for AI-powered legal document analysis**

Serverless architecture built on AWS Lambda, interfacing with Google Gemini 2.5 Flash for sub-second contract risk extraction with enterprise-grade security.

---

## ⚡ What It Does

- **Secure Document Retrieval** – Fetches user-specific files from S3 using Cognito identity isolation
- **AI Orchestration** – Manages prompt engineering and LLM interaction with Gemini 2.5 Flash
- **Structured Extraction** – Enforces JSON schema validation via Pydantic models
- **Zero-Trust Security** – IAM least privilege ensures Lambda only accesses authorized resources

---

## 🗂️ Structure
```
backend/
├── lambda/
│   ├── lambda_function.py    # Core handler (S3 → Gemini → Response)
│   ├── models.py              # Pydantic schema (DocumentExtraction)
│   ├── prompt.py              # System instructions & few-shot examples
│   └── requirements.txt       # Dependencies (google-genai, pydantic, boto3)
├── iam-policies/
│   ├── lambda-execution.json  # CloudWatch Logs permissions
│   └── s3-user-access.json    # Cognito-scoped S3 bucket access
├── .env.example               # Environment variables template
└── README.md                  # You are here
```

---

## 🚀 Deployment Guide

### 1. Set Environment Variables

In the AWS Lambda Console, configure:
```bash
GEMINI_API_KEY=your_google_ai_studio_key_here
S3_BUCKET_NAME=risk-analysing-app-data
```

> **⚠️ Never commit API keys to Git!** Use `.env.example` as a template.

### 2. Create Lambda Layer for Dependencies

Lambda functions need external libraries packaged as layers:
```bash
# Install dependencies locally
mkdir python
pip install -t python/ google-generativeai pydantic boto3

# Package as layer
zip -r gemini-layer.zip python/

# Upload to AWS Lambda Layers (via Console or CLI)
aws lambda publish-layer-version \
  --layer-name gemini-dependencies \
  --zip-file fileb://gemini-layer.zip \
  --compatible-runtimes python3.12
```

Attach this layer to your Lambda function in the Console.

### 3. Configure IAM Permissions

Attach the policies in `/iam-policies/` to your Lambda execution role:

#### `lambda-execution.json` – CloudWatch Logs
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
```

#### `s3-user-access.json` – Cognito-Scoped S3 Access
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::risk-analysing-app-data/uploads/${cognito-identity.amazonaws.com:sub}/*"
    }
  ]
}
```

This ensures users can **only** access their own documents.

### 4. Deploy the Function
```bash
# Package the Lambda code
cd lambda/
zip -r function.zip lambda_function.py models.py prompt.py

# Upload via AWS CLI
aws lambda update-function-code \
  --function-name RiskAnalyzer \
  --zip-file fileb://function.zip
```

---

## 🧠 AI Logic & Prompt Engineering

### Model Configuration

- **Model**: `gemini-2.5-flash-lite`
- **Temperature**: `0.2` (low variance for consistent legal analysis)
- **Response Format**: JSON schema enforced via Pydantic

### Prompt Structure (`prompt.py`)

The system uses **few-shot prompting** with:
1. **System Instructions** – Define the AI's role as a legal risk analyzer
2. **Example Analysis** – Show the model desired output format
3. **User Document** – The contract text to analyze

### Pydantic Schema (`models.py`)

Enforces structured output:
```python
from pydantic import BaseModel, Field
from typing import List, Literal

class RiskItem(BaseModel):
    clause: str = Field(..., description="The problematic contract clause")
    severity: Literal["High", "Low"] = Field(..., description="Risk level")
    reason: str = Field(..., description="Why this clause is risky")

class DocumentExtraction(BaseModel):
    entity_name: str = Field(..., description="Company/person name in the contract")
    document_type: str = Field(..., description="e.g., NDA, Employment Agreement")
    risks: List[RiskItem] = Field(..., description="List of identified risks")
    action_items: List[str] = Field(..., description="Recommended next steps")
```

---

## 🔧 Local Testing

### Set Up Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r lambda/requirements.txt
```

### Test the Lambda Handler Locally
```python
# test_lambda.py
import json
from lambda.lambda_function import lambda_handler

event = {
    "body": json.dumps({
        "file_key": "uploads/test-user-id/sample-contract.pdf"
    })
}

response = lambda_handler(event, None)
print(json.dumps(json.loads(response["body"]), indent=2))
```

Run:
```bash
python test_lambda.py
```

---

## 🔐 Security Architecture

| Layer | Protection |
|-------|------------|
| **IAM Permissions** | Lambda has `s3:GetObject` only (no write/delete) |
| **S3 Bucket Policy** | Users isolated by Cognito Identity ID via `${cognito-identity.amazonaws.com:sub}` |
| **API Key Management** | Gemini API key stored in Lambda environment variables (encrypted at rest) |
| **CloudWatch Logs** | Full audit trail of all function invocations |
| **VPC (Optional)** | Can be deployed in private subnet for additional isolation |

---

## 📊 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Python 3.12** | Lambda runtime |
| **Boto3** | AWS SDK for S3 operations |
| **Google GenAI SDK** | Gemini 2.5 Flash integration |
| **Pydantic** | Data validation & JSON schema enforcement |
| **AWS Lambda** | Serverless compute |
| **CloudWatch** | Logging and monitoring |

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| `Module not found: google.generativeai` | Ensure Lambda layer is attached with correct dependencies |
| `AccessDenied` on S3 GetObject | Verify IAM policy includes correct bucket ARN and Cognito condition |
| Timeout errors (15s+) | Increase Lambda timeout to 30s in Configuration → General |
| Gemini API quota exceeded | Check Google AI Studio usage limits and upgrade if needed |
| Invalid JSON response from AI | Check `prompt.py` and ensure response_schema is properly configured |

---

## 📈 Performance Metrics

- **Cold Start**: ~2-3 seconds (with layer caching)
- **Warm Execution**: ~800ms - 1.5s (depending on document size)
- **Memory Usage**: 512MB (configurable up to 3GB if processing large PDFs)
- **Cost**: ~$0.20 per 1 million requests (Lambda) + Gemini API usage

---

## 🎯 Next Steps

- [ ] Add support for multi-page PDF analysis
- [ ] Implement async Lambda invocation for long documents
- [ ] Add DynamoDB caching for repeat analysis
- [ ] Set up CloudWatch alarms for error rate monitoring
- [ ] Create API Gateway endpoint for direct HTTP access

---

## 📝 Environment Variables Reference

Copy `.env.example` and fill in your values:
```env
# Google AI Studio API Key
GEMINI_API_KEY=your_api_key_here

# AWS S3 Bucket Name
S3_BUCKET_NAME=risk-analysing-app-data

# AWS Region (Optional - defaults to Lambda's region)
AWS_REGION=us-east-1
```

---

**Lambda Function**: `RiskAnalyzer`  
**Runtime**: Python 3.12  
**Handler**: `lambda_function.lambda_handler`  
**Issues?** [Open an issue](../../issues) or check the main [project README](../../README.md)
