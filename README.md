# 🌐 Web Dashboard

> **Professional, action-first workspace for instant legal document risk analysis**

A lightweight, browser-based interface that connects users directly to AI-powered contract auditing—no downloads, no installation, just results.

---

## ⚡ What It Does

- **Secure Authentication** – AWS Cognito-powered login with isolated user sessions
- **Direct S3 Upload** – Files stream securely to user-specific prefixes using AWS SDK v2
- **Live Risk Breakdown** – Color-coded severity cards (High/Medium/Low) update in real-time
- **Zero Backend Dependency** – Pure static frontend hosted on S3 with CloudFront CDN

---

## 🗂️ Structure
```
web/
├── assets/
│   └── images/       # Logo and branding assets
├── index.html        # Landing page
├── login.html        # Sign in interface
├── register.html     # Sign up interface
├── dashboard.html    # Analysis workspace
├── .env.example      # AWS configuration template
└── README.md         # You are here

```

---

## 🚀 Quick Start

### 1. Configure AWS Credentials

Copy `.env.example` and fill in your AWS details:
```env
IDENTITY_POOL_ID=us-east-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
USER_POOL_ID=us-east-1_XXXXXXXXX
BUCKET_NAME=risk-analysing-app-data
REGION=us-east-1
```

Alternatively, update the constants directly in the HTML files (search for `AWS.config`).

### 2. Launch Locally
```bash
# Option A: Open directly
open index.html

# Option B: Use a local server (recommended for testing)
python -m http.server 8000
# Then visit: http://localhost:8000
```

### 3. Deploy to Production
```bash
# Sync to S3
aws s3 sync . s3://your-bucket-name --exclude ".git/*" --exclude "*.md"

# Enable static website hosting in S3 bucket settings
# Set index.html as the index document
```

---

## 🔐 Security

- **User Isolation**: Cognito Identity IDs ensure users only access their own documents
- **CORS Policy Required**: Your S3 bucket must allow requests from your hosted domain
- **No API Keys in Code**: All AWS credentials are managed via Cognito temporary credentials

### Example S3 CORS Configuration
```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST"],
    "AllowedOrigins": ["https://yourdomain.com"],
    "ExposeHeaders": ["ETag"]
  }
]
```

---

## 🎨 Tech Stack

| Technology | Purpose |
|------------|---------|
| **HTML5/CSS3** | Structure & styling |
| **Bootstrap 5** | Responsive grid & components |
| **AWS SDK v2 (JS)** | Cognito auth + S3 uploads |
| **Vanilla JavaScript** | No frameworks = faster load times |

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Identity Pool not authorized" | Check IAM roles attached to your Cognito Identity Pool |
| CORS errors on upload | Verify S3 bucket CORS policy matches your domain |
| Dashboard blank after login | Check browser console for Cognito token errors |

---

## 📝 Next Steps

- [ ] Add CloudFront distribution for HTTPS + global CDN
- [ ] Implement session timeout warnings
- [ ] Add file type validation on the frontend

---

**Live Demo**: [Your deployed URL here]  
**Issues?** [Open an issue](../../issues) or check the main [project README](../../README.md)