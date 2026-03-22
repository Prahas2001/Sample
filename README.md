# AI Legal Risk Analyzer

<div align="center">

**⚖️ Automated legal document auditing powered by AI**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![AWS](https://img.shields.io/badge/AWS-Lambda%20%7C%20S3%20%7C%20Cognito-FF9900?logo=amazon-aws)](https://aws.amazon.com)
[![Gemini](https://img.shields.io/badge/Google-Gemini%202.5%20Flash-4285F4?logo=google)](https://ai.google.dev)

[Demo](#-demo) • [Features](#-features) • [Architecture](#-architecture) • [Quick Start](#-quick-start) • [Documentation](#-documentation)

</div>

---

## 📖 Overview

A professional, cloud-native platform for instant legal document risk analysis. Upload contracts, NDAs, or agreements and receive structured risk assessments in seconds—no legal expertise required.

**Built for:**
- 🧑‍💼 Freelancers reviewing client contracts
- 🏢 Small business owners vetting vendor agreements  
- ⚖️ Legal professionals conducting first-pass audits

---

## ✨ Features

### 🎯 Core Capabilities

- **Instant Risk Detection** – AI identifies hidden liabilities, unfair clauses, and compliance issues
- **Severity Classification** – Color-coded ratings (High/Medium/Low) with contextual explanations
- **Multi-Format Support** – Process PDFs and images (JPG/PNG) via OCR
- **Cross-Platform** – Native mobile app + responsive web dashboard
- **Secure & Private** – User-isolated S3 storage with AWS Cognito authentication

### 🎨 Design System

Built with a professional **Heritage Navy (#0F172A)** and **Brand Amber (#B45309)** color palette for authority and action.

---

## 🏗️ Architecture
```
      ┌─────────────┐          ┌──────────────┐
      │   Mobile    │          │     Web      │
      │  (Flutter)  │          │  Dashboard   │
      └──────┬──────┘          └──────┬───────┘
             │                        │
             └───────────┐   ┌────────┘
                         ▼   ▼
┌──────────────────────────────────────────────────────────────┐
│                    AWS Infrastructure                        │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌──────────────┐  │
│  │ Cognito │   │   S3    │   │ Lambda  │   │ Gemini 2.5   │  │
│  │  Auth   │   │ Storage │   │ Python  │   │ Flash (API)  │  │
│  └─────────┘   └─────────┘   └─────────┘   └──────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

### Tech Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Mobile** | Flutter (Dart) | Cross-platform native app |
| **Web** | HTML5 + Bootstrap 5 | Static dashboard |
| **Backend** | AWS Lambda (Python 3.12) | Serverless compute |
| **AI** | Google Gemini 2.5 Flash | Legal text analysis |
| **Auth** | AWS Cognito | User authentication |
| **Storage** | Amazon S3 | Document storage |
| **Validation** | Pydantic | JSON schema enforcement |

---

## 🚀 Quick Start

### 📱 Mobile App (Android)

1. **Download the APK**  
   Get the latest release: [`LegalRisk_v1.0.apk`](./releases/mobile/LegalRisk_v1.0.apk)

2. **Install**  
   Follow the [installation guide](./releases/mobile/install_instructions.md)

3. **Launch**  
   Open the app, sign up, and start analyzing documents

**Requirements:** Android 5.0+ (API 21), 150MB storage, internet connection

### 🌐 Web Dashboard

1. **Configure AWS**  
   Copy `web/.env.example` and fill in your credentials

2. **Launch Locally**  
```bash
   cd web/
   open index.html
   # Or use a local server:
   python -m http.server 8000
```

3. **Deploy to S3** (Optional)  
```bash
   aws s3 sync web/ s3://your-bucket-name --exclude "*.md"
```

### ⚙️ Backend Setup

1. **Create Lambda Layer**  
```bash
   cd backend/lambda/
   pip install -t python/ google-generativeai pydantic boto3
   zip -r layer.zip python/
```

2. **Deploy Function**  
```bash
   zip -r function.zip lambda_function.py models.py prompt.py
   aws lambda update-function-code --function-name RiskAnalyzer --zip-file fileb://function.zip
```

3. **Set Environment Variables**  
```bash
   aws lambda update-function-configuration \
     --function-name RiskAnalyzer \
     --environment Variables="{GEMINI_API_KEY=your_key,S3_BUCKET_NAME=your_bucket}"
```

---

## 📂 Project Structure
```
ai-legal-risk-analyzer/
├── app/                    # Flutter mobile application
│   ├── lib/                # Dart source code
│   ├── android/            # Android build config
│   └── README.md           # Mobile setup guide
├── web/                    # Static web dashboard
│   ├── dashboard.html      # Main workspace
│   └── README.md           # Web deployment guide
├── backend/                # AWS Lambda functions
│   ├── lambda/             # Python source code
│   ├── iam-policies/       # Security policies
│   └── README.md           # Backend deployment guide
├── releases/               # Pre-built APK files
│   └── CHANGELOG.md        # Version history
├── docs/                   # Documentation assets
│   └── screenshots/        # UI gallery
└── README.md               # You are here
```

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Mobile App Guide](./app/README.md) | Flutter setup, build instructions, ProGuard config |
| [Web Dashboard Guide](./web/README.md) | HTML deployment, AWS SDK integration |
| [Backend Guide](./backend/README.md) | Lambda deployment, IAM policies, AI logic |
| [Installation Instructions](./releases/mobile/install_instructions.md) | APK installation steps |
| [Changelog](./releases/CHANGELOG.md) | Version history and release notes |

---

## 🔐 Security

- **Zero-Trust Architecture** – Users can only access their own documents
- **IAM Least Privilege** – Lambda has minimal S3 permissions
- **Encrypted Transit** – All data sent via HTTPS
- **No API Keys in Code** – Credentials managed via Cognito temporary tokens
- **Audit Trail** – Full CloudWatch Logs for all operations

See [Security Documentation](./backend/README.md#security-architecture) for details.

---

## 🎯 Key Technical Achievements

✅ **Stable AI Output** – Pydantic schema validation ensures 100% UI reliability  
✅ **Mobile Optimization** – R8/ProGuard shrinking reduced APK from 120MB → 70MB  
✅ **User Isolation** – S3 bucket policies enforce Cognito-based path restrictions  
✅ **Design System** – Consistent Heritage Navy + Brand Amber branding across platforms  
✅ **Serverless Scale** – Lambda auto-scales from 0 to 1000+ concurrent requests

---

## 🐛 Troubleshooting

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| Mobile app won't install | Ensure Android 5.0+, enable "Unknown sources" |
| Web dashboard login fails | Check Cognito User Pool ID in `web/` config |
| Lambda timeout errors | Increase timeout to 30s in AWS Console |
| Gemini API quota exceeded | Upgrade to paid tier in Google AI Studio |

More help: [Open an issue](../../issues)

---

## 🗺️ Roadmap

### v1.1 (Q2 2025)
- [ ] iOS mobile app
- [ ] Multi-page PDF support
- [ ] Document analysis history

### v1.2 (Q3 2025)
- [ ] Export reports as PDF
- [ ] Biometric authentication
- [ ] Dark mode UI

See [full roadmap](./releases/CHANGELOG.md#unreleased)

---

## 📝 License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) for details.

---

## 👤 Author

**D Ram Prahasith Sharma**  
MSc Data Science, DAU

📧 Email: [ramprahasith01@gmail.com]  
🔗 LinkedIn: [https://www.linkedin.com/in/ram-prahasith-sharma-87a8662a6/]  
🐙 GitHub: [Prahas2001](https://github.com/Prahas2001)

---

## 🙏 Acknowledgments

- **Google AI Studio** for Gemini API access
- **AWS** for cloud infrastructure
- **Flutter Team** for the cross-platform framework

---

<div align="center">

**⭐ Star this repo if you found it helpful!**

[Report Bug](../../issues) • [Request Feature](../../issues) • [View Demo](#)

</div>

---

© 2026 D Ram Prahasith Sharma. All rights reserved.
