# video_call_app

A new Flutter project.

## Build & Run

### Prerequisites
- Flutter SDK installed (`3.8+`).
- Xcode (for iOS) and/or Android Studio + Android SDK (for Android).
- An Agora account with an App ID and a temp token for testing.

### 1) Configure Agora
Update the hardcoded values in `lib/core/utils/agora_config.dart`:

```dart
class AgoraConfig {
  static const String appId = 'YOUR_AGORA_APP_ID';
  static const String channel = 'video_call_app_channel';
  static const String token = 'YOUR_TEMP_TOKEN';
}
```

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Run on Android

```bash
flutter run -d android
```

Notes (Android):
- The app requests Camera and Microphone permissions at runtime.
- Screen sharing uses Android Media Projection; accept the system prompt when starting share.

### 4) Run on iOS

```bash
flutter run -d ios
```

Notes (iOS):
- Open `ios/Runner.xcworkspace` in Xcode and set a Development Team if needed.
- Ensure camera/microphone usage descriptions exist in `ios/Runner/Info.plist` (already added).

### 5) Using the app
- Login (or open Dashboard) → select the `Videocall` tab.
- Pre-join screen shows the channel and link; tap "Join Channel" to start the call.
- Use the bottom toolbar to mute/unmute mic, enable/disable camera, start/stop screen sharing, and end the call.

### Testing
- Launch the app on two devices/emulators and join the same channel (`video_call_app_channel`).
- Verify local preview (PIP), remote video, and control toggles. Screen sharing should replace the camera feed when enabled.

## Android Release Build

The project is preconfigured to sign release builds using `android/key.properties` and a keystore file referenced there.

### 1) Keystore setup
- Ensure `android/key.properties` exists with:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=/absolute/path/to/your/keystore.jks
```

- A sample keystore is in the repo at `android/app/video-call-app.jks`. Point `storeFile` to it or your own keystore path.

### 2) Build signed APK

```bash
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`

### 3) Build signed App Bundle (for Play Console)

```bash
flutter build appbundle --release
```

AAB output: `build/app/outputs/bundle/release/app-release.aab`

### 4) Versioning
- Update version in `pubspec.yaml`, e.g. `version: 1.1.0+2`.
- `build.gradle.kts` uses Flutter’s `versionName` and `versionCode` automatically.

### 5) Common issues
- If signing fails, verify the absolute `storeFile` path and passwords in `android/key.properties`.
- If Play Console warns about permissions, confirm `android/app/src/main/AndroidManifest.xml` includes Camera/Microphone and foreground service permissions (already added for screen sharing).
