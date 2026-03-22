# 📱 Mobile App (Flutter)

> **Cross-platform legal risk analyzer for on-the-go document auditing**

Native Android/iOS application built with Flutter, delivering 60fps performance and enterprise-grade security for mobile contract analysis.

---

## ⚡ What It Does

- **Native Performance** – AOT compilation ensures smooth animations and instant responsiveness
- **AWS Amplify Integration** – Secure auth + S3 uploads via official Flutter SDK
- **Real-time Feedback** – Brand Amber (#B45309) scanning animations during analysis
- **Production Security** – R8 code shrinking and obfuscation for minimal attack surface

---

## 🗂️ Structure
```
app/
├── android/              # Native Android config + ProGuard rules
├── ios/                  # Native iOS config (future release)
├── lib/
│   ├── models/           # Data structures (RiskItem, AnalysisResult)
│   └── main.dart         # Core app logic + Heritage Navy UI
├── assets/
│   └── images/           # Brand assets and app icons
├── pubspec.yaml          # Flutter dependencies
├── .gitignore            # Excludes build/ and .idea/
└── README.md             # You are here

```

---

## 🚀 Quick Start

### 1. Prerequisites

Ensure Flutter is installed and configured:
```bash
flutter doctor
# All checks should pass (Android toolchain, VS Code/Android Studio)
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure AWS

Update `amplifyconfig` in `lib/main.dart` with your credentials:
```dart
final amplifyconfig = '''{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserPoolId": "us-east-1_XXXXXXXXX",        // ← Your User Pool
        "IdentityPoolId": "us-east-1:xxxxx...",      // ← Your Identity Pool
        "Region": "us-east-1"
      }
    }
  },
  "storage": {
    "plugins": {
      "awsS3StoragePlugin": {
        "bucket": "risk-analysing-app-data",         // ← Your Bucket
        "region": "us-east-1"
      }
    }
  }
}''';
```

### 4. Run on Device

Connect an Android device via USB (enable Developer Mode + USB Debugging):
```bash
# Check device connection
flutter devices

# Launch in release mode
flutter run --release
```

---

## 📦 Building the APK

### Generate Release Build
```bash
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk` (~70MB)

### What Happens During Build

1. **Icon Tree-Shaking** – Reduces Material Icons from 1.6MB → 4KB
2. **R8 Code Shrinking** – Removes unused code and obfuscates classes
3. **ProGuard Rules Applied** – Custom rules suppress AWS/Crypto warnings

---

## 🔧 Build Optimization Details

### ProGuard Configuration

The release build uses custom rules in `android/app/proguard-rules.pro` to handle missing annotations from AWS Amplify and Google Tink:
```proguard
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
```

Without these rules, R8 throws warnings that prevent successful APK generation.

### Gradle Configuration

Key settings in `android/app/build.gradle`:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        signingConfig signingConfigs.release
    }
}
```

---

## 🔐 Security

- **No API Keys in Code** – All AWS credentials managed via Cognito temporary tokens
- **Identity Isolation** – Each user's documents stored in isolated S3 prefixes
- **In-Memory Processing** – Documents analyzed in real-time; no persistent local storage
- **HTTPS-Only** – All S3 uploads encrypted in transit
- **Code Obfuscation** – R8 makes reverse engineering significantly harder

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| `flutter doctor` fails | Install Android Studio and accept SDK licenses |
| ProGuard warnings | Ensure `proguard-rules.pro` exists with AWS exclusions |
| APK won't install | Check Android version (requires API 21+) |
| Cognito auth fails | Verify `amplifyconfig` credentials in `main.dart` |
| Upload freezes | Check internet connection and S3 bucket permissions |

---

## 📱 Supported Platforms

| Platform | Status | Min Version |
|----------|--------|-------------|
| **Android** | ✅ Released | API 21 (Android 5.0) |
| **iOS** | 🚧 Planned | iOS 12+ |

---

## 📝 Current Version

**v1.0.0** – Initial production release

### Release Notes
- ✅ AWS Cognito authentication
- ✅ S3 document upload with progress indicator
- ✅ Real-time risk analysis via Lambda
- ✅ Color-coded severity cards (High/Medium/Low)
- ✅ Heritage Navy + Brand Amber theming

---

## 🎯 Next Steps

- [ ] Add iOS build configuration
- [ ] Implement biometric authentication
- [ ] Add offline document queue
- [ ] Integrate push notifications for analysis completion

---

**Download APK**: [releases/mobile/LegalRisk_v1.0.apk](../../releases/mobile/LegalRisk_v1.0.apk)  
**Issues?** [Open an issue](../../issues) or check the main [project README](../../README.md)