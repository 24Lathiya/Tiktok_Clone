# tiktok_clone

Tiktok Clone with Firebasa and GetX

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

- Configure Firebase Authentication for Android
  - get package name (search 'applicationId')
  - get google_service.json and add to android app folder.
  - follow firebase instruction to implement dependencies.
  - app gradle -->  minimumSdk 21 & multiDexEnable true
  
- Configure Firebase Authentication for iOS
  - get package name (search for 'PRODUCT_BUNDLE_IDENTIFIER')
  - get GoogleService-Info.plist and add to ios Runner folder.
  - terminal --> cd ios 
  - pod init (if pod is not available)
  - ios/Podfile --> uncomment --> platform :ios, '12.0'
  - pod install
  
- Configure Firebase Cloud Filestore
  - create firebase cloud
  - change rules (allow read, write : if false - > if(request.auth != null))

# Tiktok_Clone
