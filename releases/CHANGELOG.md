# 📜 Changelog

All notable changes to the AI Legal Risk Analyzer project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-03-21

### 🎉 Initial Production Release

The first stable version of the AI Legal Risk Analyzer, featuring cross-platform deployment and enterprise-grade security.

#### ✨ Features

**AI & Analysis**
- Integrated **Google Gemini 2.5 Flash** for sub-second legal document risk extraction
- Pydantic-enforced JSON schema guarantees 100% UI stability (no parsing errors)
- Structured output with severity classification (High/Medium/Low risks)
- Entity name and document type auto-detection

**Mobile Application**
- Flutter-based Android app with native 60fps performance
- R8/ProGuard code shrinking and obfuscation (70.1 MB APK)
- AWS Amplify SDK integration for seamless auth + storage
- Real-time upload progress with Brand Amber (#B45309) scanning animations
- Minimum Android version: 5.0 (API 21)

**Web Dashboard**
- Static HTML/CSS/JS interface hosted on AWS S3
- Bootstrap 5 responsive design with glassmorphism effects
- Direct-to-S3 file uploads via AWS SDK v2
- Color-coded risk visualization cards
- Heritage Navy (#0F172A) + Brand Amber design system

**Backend Infrastructure**
- AWS Lambda serverless compute (Python 3.12 runtime)
- Zero-trust architecture with IAM least privilege
- Cognito-scoped S3 access (users isolated by Identity ID)
- CloudWatch Logs for full audit trail
- Sub-2-second cold start with optimized Lambda layers

**Security**
- AWS Cognito user pools with secure token-based authentication
- S3 bucket policies enforce user-specific prefixes (`uploads/${cognito-identity-id}/`)
- No API keys in client code (managed via Cognito temporary credentials)
- HTTPS-only data transmission
- In-memory document processing (no persistent local storage on mobile)

**Documentation**
- Comprehensive README files for web, mobile, and backend
- Deployment guides with step-by-step instructions
- Troubleshooting sections for common issues
- Architecture documentation and security notes

#### 🔧 Technical Details

**Dependencies**
- `google-generativeai` (Python) - Gemini API client
- `pydantic` (Python) - Data validation
- `boto3` (Python) - AWS SDK
- `amplify_flutter` (Dart) - AWS mobile SDK
- `aws-sdk-v2` (JavaScript) - Browser S3 uploads

**Infrastructure**
- **Storage**: Amazon S3 (`risk-analysing-app-data`)
- **Compute**: AWS Lambda (512 MB memory, 30s timeout)
- **Auth**: Amazon Cognito (User Pools + Identity Pools)
- **AI Model**: Gemini 2.5 Flash (`gemini-2.5-flash-lite`)

#### 📦 Release Assets

- `LegalRisk_v1.0.apk` (70.1 MB) - Android application
- Source code (web + mobile + backend)
- Complete documentation suite

#### 🎯 Known Limitations

- iOS build not yet available (planned for v1.1)
- Single-page PDF analysis only (multi-page support in v1.2)
- No offline mode (requires active internet connection)
- English language documents only

---

## [Unreleased]

### 🚧 Planned Features

- **iOS Support** - Native iPhone/iPad application
- **Multi-page Analysis** - Process contracts longer than 10 pages
- **Document History** - View past analyses in dashboard
- **Export Options** - Download risk reports as PDF
- **Biometric Auth** - Face/fingerprint login for mobile
- **Push Notifications** - Alert when analysis completes
- **Dark Mode** - UI theme toggle
- **Multi-language** - Support for Spanish, French, German contracts

---

## Version History

| Version | Release Date | Status |
|---------|--------------|--------|
| **1.0.0** | 2025-03-21 | ✅ Current Stable |
| 0.9.0-beta | 2025-03-10 | 🧪 Internal Testing |
| 0.8.0-alpha | 2025-02-28 | 🔬 Development |

---

## Upgrade Guide

### From Beta (0.9.0) to Stable (1.0.0)

**Mobile App**
1. Uninstall the beta APK
2. Install `LegalRisk_v1.0.apk`
3. Re-login with your credentials (sessions not preserved)

**Web Dashboard**
- No changes required - static files auto-updated on S3

**Backend**
- Update Lambda function code with new `lambda_function.py`
- Ensure environment variable `GEMINI_API_KEY` is set
- Verify IAM policies match new `iam-policies/` templates

---

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for details on how to submit changes or report issues.

---

**Latest Release**: [v1.0.0](https://github.com/yourusername/ai-legal-risk-analyzer/releases/tag/v1.0.0)  
**Full Changelog**: [View all releases](https://github.com/yourusername/ai-legal-risk-analyzer/releases)