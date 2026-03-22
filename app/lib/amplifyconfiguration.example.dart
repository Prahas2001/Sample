// lib/amplifyconfiguration.example.dart
// INSTRUCTIONS: Copy this file to 'amplifyconfiguration.dart' 
// and replace the XXXXXXXX values with your AWS Resource IDs.

const amplifyconfig = '''{
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": { "Default": {} },
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "ap-south-1:xxxx-xxxx-xxxx-xxxx",
              "Region": "ap-south-1"
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "ap-south-1_XXXXXXXXX",
            "AppClientId": "xxxxxxxxxxxxxxxxxxxxxxxxxx",
            "Region": "ap-south-1"
          }
        }
      }
    }
  }
}''';