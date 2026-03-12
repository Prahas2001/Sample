# AI Legal Risk Analyzer: Cross-Platform Suite

A **secure, serverless, cloud-native solution** designed for **automated legal and clinical document risk assessment**. The platform leverages modern AI capabilities and scalable cloud infrastructure to analyze documents, identify potential risks, and deliver structured insights across multiple platforms.



## Project Overview

The **AI Legal Risk Analyzer** addresses the high cognitive load involved in reviewing dense legal contracts and clinical reports. It provides a **unified ecosystem**—comprising a **responsive web dashboard** and a **cross-platform mobile application**—that enables users to upload documents and receive a **structured, AI-generated risk profile**.

The system automates document analysis, helping users quickly identify potential risks, critical clauses, and key insights that would otherwise require extensive manual review.



## Features

### AI-Powered Document Analysis
Automated extraction of key legal entities and clinical findings using **Google Gemini 2.0 Flash-Lite**.

### Intelligent Risk Classification
Identifies and categorizes potential issues into **High**, **Medium**, or **Low** severity levels, accompanied by detailed AI-generated reasoning.

### Cross-Platform Access
Provides a synchronized user experience across a **specialized Web Dashboard** and a **high-performance Flutter Mobile App**.

### Zero-Trust Storage
Implements **fine-grained Amazon S3 pathing**, ensuring each user’s data is isolated within private folders mapped to their unique **Cognito Identity ID**.

### Multimodal Support
Supports analysis of **high-resolution document images (JPG/PNG)** as well as **multi-page PDF files**.

## System Architecture

The system follows a **modern cloud-native architecture**, where the **frontend manages user interaction and state**, while the **backend handles processing, storage, and AI-driven analysis**.

### Identity
**AWS Cognito** (User Pools & Identity Pools)  
Manages user authentication and authorization, providing secure identity management across the platform.

### Storage
**Amazon S3**  
Object storage with **IAM-based prefix isolation**, ensuring that each user's documents are securely stored within private, access-controlled paths.

### Compute
**AWS Lambda (Python 3.12 Runtime)**  
Serverless compute layer responsible for document processing, orchestration, and interaction with the AI analysis service.

### AI Layer
**Google Gemini 2.0 Flash-Lite**  
Performs document analysis and generates structured outputs used for legal and clinical risk assessment.



## Tech Stack

| Tier | Technology |
|-----|-----|
| **Mobile** | Flutter (Dart), AWS Amplify, Syncfusion PDF Viewer |
| **Web** | HTML5, JavaScript (ES6+), Bootstrap 5, AWS JavaScript SDK (v2) |
| **Backend** | AWS Lambda, Amazon API Gateway, Boto3 (Python) |
| **AI Model** | Google Gemini 2.0 Flash-Lite |
| **Data Validation** | Pydantic (Data Schemas) |



## Project Structure
/ai-risk-analyzer
│
├── /mobile_app # Flutter source code
│ ├── /lib # Dart logic & UI components
│ └── pubspec.yaml # Mobile dependencies
│
├── /web_dashboard # Web frontend
│ └── dashboard.html # Bootstrap UI & AWS SDK Integration
│
├── /aws_lambda # Backend logic
│ ├── lambda_function.py # Main handler & S3 retrieval logic
│ ├── models.py # Pydantic data schemas
│ └── prompt.py # AI System Instructions & Prompt Engineering
│
└── /docs # Documentation & System Diagrams



## Installation & Setup

### Mobile Application (Flutter)

1. **Install Dependencies**

   ```bash
   flutter pub get
   ```

2. **Configure Amplify**

   Update the `amplifyconfig` string in `lib/main.dart` with your **AWS Resource IDs**.

3. **Launch the Application**

   ```bash
   flutter run
   ```

---

### Web Dashboard

1. **Navigate to the Dashboard Directory**

   ```bash
   cd web_dashboard
   ```

2. **Update AWS Configuration**

   Update the `AWS.config` constants inside `dashboard.html`.

3. **Open the Dashboard**

   Open `dashboard.html` in **any modern web browser** to launch the dashboard.



## Deployment Guide (AWS & AI Setup)

### Step 1: IAM Role Configuration

**Authenticated Role**

Attach an inline policy that allows the following permission:

- `s3:PutObject` on  
  `arn:aws:s3:::risk-analysing-app-data/uploads/${cognito-identity.amazonaws.com:sub}/*`

This allows authenticated users to upload documents to their own folder in the S3 bucket.

**Lambda Role**

The Lambda execution role must include the following permission:

- `s3:GetObject` access for the `risk-analysing-app-data` S3 bucket.

This allows the Lambda function to retrieve uploaded documents for processing.

---

### Step 2: Lambda Environment

Add the following **environment variable** to your Lambda function:

```bash
GEMINI_API_KEY=your_google_ai_studio_api_key
```
The API key should be obtained from Google AI Studio and is used to enable AI-powered legal document analysis.



## Usage

1. **Authentication**

   Register or log in using either the **mobile application** or the **web dashboard**.

2. **Pick Document**

   Select a **PDF** or **image file** that contains legal or clinical text you want to analyze.

3. **Set Context (Optional)**

   In the **User Prompt** field, you can provide a specific instruction or context for the analysis.

   Example:
   ```text
   Look for hidden costs
   ```

4. **Analyze**
   
   Trigger the analysis process. The selected file will:

   - Be uploaded to **AWS S3**
   - Be processed by **AWS Lambda**
   - Be analyzed using the **Gemini AI model**

   The results are then streamed back to the application.

5. **Review Results**
   
   Examine the **color-coded severity cards** on the dashboard to identify potential risks and important clauses detected in the document.



## AI Analysis Output Schema

The AI analysis returns results in the following **JSON structure**:

```json
{
  "entity_name": "Agreement Name",
  "summary": "Brief overview of the document contents.",
  "risks": [
    {
      "severity": "High",
      "reason": "Specific risk detail."
    }
  ]
}
```



## Troubleshooting

### 403 Access Denied
Check the following:
- **S3 CORS configuration**
- **Amazon Cognito IAM policies**

These must allow the required permissions for uploading and accessing files.

### 429 Resource Exhausted
This error indicates that the **Gemini Free Tier rate limit** has been reached.

Possible solutions:
- Wait **~60 seconds** before retrying
- Update or replace the `GEMINI_API_KEY`

### 502 Internal Server Error
Check **AWS CloudWatch Logs** for details.

Common cause:
- **Python indentation errors** or runtime exceptions in the **Lambda function**.



## License

Copyright © 2026 Ram Prahasith Sharma.

This project is licensed under the **MIT License**. You are free to use, modify, and distribute this software for academic or personal purposes, provided that appropriate credit is given to the original author.



## Author

**Ram Prahasith Sharma**  
MSc Data Science, DAU.

