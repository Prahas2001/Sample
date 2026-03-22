# 📥 APK Installation Guide

> **Quick guide to installing AI Risk Analyzer on Android devices**

---

## 📱 Installation Steps

### 1. Download the APK

Transfer `LegalRisk_v1.0.apk` to your Android device using one of these methods:

- **Direct Download**: Open the GitHub release page on your phone's browser
- **USB Transfer**: Connect phone to computer and copy to `Downloads/` folder
- **Cloud Storage**: Upload to Google Drive/Dropbox and download on phone

### 2. Enable Installation from Unknown Sources

Android blocks APK installations by default for security. You'll need to grant permission:

#### Android 8.0+ (Oreo and newer)
1. Tap the APK file
2. When prompted, tap **Settings**
3. Toggle **"Allow from this source"**
4. Press back and tap the APK again

#### Android 7.1 and older
1. Go to **Settings** → **Security**
2. Enable **"Unknown sources"**
3. Confirm the warning dialog

### 3. Install the Application

1. Locate the APK in your **Downloads** folder or **Files** app
2. Tap `LegalRisk_v1.0.apk`
3. Review the permissions requested:
   - **Internet** (for AWS communication)
   - **Storage** (for document selection)
4. Tap **Install**
5. Wait for installation to complete (~10 seconds)

### 4. Launch the App

- Find **AI Risk Analyzer** in your app drawer (look for the Heritage Navy icon)
- First launch may take 3-5 seconds to initialize AWS SDK
- You'll be greeted with the login/registration screen

---

## ⚙️ System Requirements

| Requirement | Minimum |
|-------------|---------|
| **Android Version** | 5.0 (Lollipop) / API 21 |
| **Storage Space** | 150 MB free |
| **RAM** | 2 GB |
| **Internet** | Required (Wi-Fi or mobile data) |
| **Screen Size** | 4.5" or larger recommended |

---

## 🔐 Security Notice

This APK is **not distributed via Google Play Store**, which means:

- ✅ No Google Play Protect scanning (you control the source)
- ✅ Direct installation from GitHub releases
- ⚠️ **Only download from official repository**: `github.com/yourusername/ai-legal-risk-analyzer`

**Why no Play Store?**  
This is a portfolio/academic project. Play Store distribution requires:
- Developer account ($25 one-time fee)
- Privacy policy hosting
- Content rating questionnaire
- Ongoing compliance reviews

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| "App not installed" error | Uninstall any previous version first |
| "Parse error" message | Re-download APK (file may be corrupted) |
| Can't find "Unknown sources" | Search Settings for "Install unknown apps" |
| App crashes on launch | Ensure Android 5.0+ and 2GB+ RAM |
| Login fails | Check internet connection and AWS Cognito status |

---

## 🔄 Updating to Newer Versions

When a new release is available:

1. Download the new APK (e.g., `LegalRisk_v1.1.apk`)
2. Install directly over the existing app
3. Your login session and preferences will be preserved
4. No need to uninstall first (unless experiencing issues)

---

## 🗑️ Uninstallation

To remove the app:

1. **Settings** → **Apps** → **AI Risk Analyzer**
2. Tap **Uninstall**
3. Confirm

**Note**: This removes the app but does **not** delete your documents stored in AWS S3. Those remain in your cloud account.

---

## 📞 Need Help?

- **Issues?** [Report a bug](../../issues)
- **Questions?** Check the [main README](../../README.md)
- **Security concerns?** Review the [app security documentation](../../app/README.md#security)

---

**Current Version**: v1.0.0  
**File Size**: 70.1 MB  
**Release Date**: [Your release date]  
**SHA-256 Checksum**: [Optional - add for extra security verification]
