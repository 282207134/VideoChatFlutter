# Video Chat App

A Flutter video chat application built with Agora RTC SDK for real-time video communication.

## Features

- 🎥 Real-time video calling
- 🎤 Audio communication
- 📱 Cross-platform (iOS & Android)
- 🔄 Camera switching
- 🔇 Mute/Unmute functionality
- 🔊 Speaker control
- 📹 Camera on/off toggle
- 👥 Multi-user support

## Prerequisites

1. Flutter SDK (>=3.0.0)
2. Dart SDK (>=3.0.0)
3. Android Studio / Xcode
4. Agora Account

## Setup

### 1. Get Agora App ID

1. Sign up at [Agora Console](https://console.agora.io/)
2. Create a new project
3. Copy the App ID from your project dashboard

### 2. Configure the App

Replace the placeholder values in `lib/video_call_screen.dart`:

```dart
await _engine.initialize(const RtcEngineContext(
  appId: 'YOUR_AGORA_APP_ID', // Replace with your Agora App ID
  channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
));
```

For production use, you should implement token authentication. Replace:
```dart
await _engine.joinChannel(
  token: 'YOUR_TOKEN_OR_LEAVE_EMPTY', // Replace with your token
  channelId: widget.channelName,
  uid: 0,
  options: const ChannelMediaOptions(
    channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    clientRoleType: ClientRoleType.clientRoleBroadcaster,
  ),
);
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Platform-Specific Setup

#### Android

No additional setup required. The app includes all necessary permissions in `android/app/src/main/AndroidManifest.xml`.

#### iOS

No additional setup required. The app includes camera and microphone permissions in `ios/Runner/Info.plist`.

## Running the App

### Android

```bash
flutter run
```

### iOS

```bash
flutter run -d ios
```

## Usage

1. Launch the app
2. Enter a channel name (any name you want to use for the video call room)
3. Grant camera and microphone permissions when prompted
4. Click "Join" to start the video call
5. Share the channel name with others to join the same call

## Controls

- **Microphone**: Mute/Unmute your audio
- **Camera**: Turn on/off your video
- **End Call**: Leave the current call
- **Speaker**: Toggle speakerphone mode
- **Switch Camera**: Switch between front and back cameras

## Token Authentication (Recommended for Production)

For production applications, you should implement token authentication:

1. Set up a token server using Agora's server SDKs
2. Generate tokens on your server
3. Fetch tokens from your Flutter app before joining channels

Example token server setup:
- Node.js: `npm install agora-token`
- Python: `pip install agora-token`
- Java: Add Agora SDK dependency

## Deployment

### Android

1. Generate a signing key:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `key.properties` in `android/`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-upload-keystore.jks>
```

3. Build the APK:
```bash
flutter build apk --release
```

4. Build the App Bundle:
```bash
flutter build appbundle --release
```

### iOS

1. Configure your app in Xcode:
   - Set Bundle Identifier
   - Set Team and Signing Certificate
   - Configure App Store Connect settings

2. Build the iOS app:
```bash
flutter build ios --release
```

3. Archive and upload via Xcode:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Product → Archive
   - Upload to App Store Connect

## API Documentation

### Agora RTC Engine Methods Used

#### Initialization
- `createAgoraRtcEngine()`: Creates Agora RTC engine instance
- `initialize()`: Initializes the engine with App ID and channel profile

#### Channel Management
- `joinChannel()`: Joins a channel with specified channel name and token
- `leaveChannel()`: Leaves the current channel
- `setClientRole()`: Sets user role (broadcaster/audience)

#### Media Control
- `enableVideo()`: Enables video module
- `startPreview()`: Starts local video preview
- `muteLocalAudioStream()`: Mutes/unmutes local audio
- `muteLocalVideoStream()`: Mutes/unmutes local video
- `switchCamera()`: Switches between front and back cameras
- `setEnableSpeakerphone()`: Enables/disables speakerphone

#### Event Handling
- `onJoinChannelSuccess`: Called when local user joins channel
- `onUserJoined`: Called when remote user joins
- `onUserOffline`: Called when remote user leaves
- `onTokenPrivilegeWillExpire`: Called when token is about to expire

### Required Permissions

#### Android
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### iOS
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to make video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to make video calls</string>
```

## Security Considerations

1. **Token Authentication**: Always use tokens in production
2. **Channel Security**: Use secure channel names and implement access control
3. **HTTPS**: Use HTTPS for token server communication
4. **App ID Security**: Keep your Agora App ID secure

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure camera and microphone permissions are granted
2. **Connection Failed**: Check App ID and network connectivity
3. **Token Expired**: Implement token refresh mechanism
4. **Video Not Showing**: Check camera permissions and hardware availability

### Debug Mode

Enable debug logging by adding this during initialization:
```dart
await _engine.initialize(RtcEngineContext(
  appId: appId,
  channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
  areaCode: AreaCode.AREA_CODE_GLOBAL,
));
```

## Support

- [Agora Documentation](https://docs.agora.io/en/)
- [Flutter Agora SDK](https://pub.dev/packages/agora_rtc_engine)
- [Agora Community](https://www.agora.io/en/community/)

## License

This project is licensed under the MIT License.