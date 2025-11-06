# 部署配置指南

## 概述

本文档详细说明了如何部署和配置基于 Agora 的 Flutter 视频聊天应用。

## 前置要求

### 开发环境
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio (用于 Android 开发)
- Xcode (用于 iOS 开发)
- Git

### Agora 账户
- 注册 [Agora 控制台](https://console.agora.io/)
- 创建项目并获取 App ID

## 配置步骤

### 1. Agora 配置

#### 1.1 获取 App ID
1. 登录 [Agora 控制台](https://console.agora.io/)
2. 点击"项目管理" → "创建项目"
3. 选择"视频通话"场景
4. 复制生成的 App ID

#### 1.2 配置 Token (生产环境必需)
对于生产环境，必须配置 Token 认证：

```javascript
// Node.js 示例 (server.js)
const Agora = require('agora-access-token');

const appID = 'YOUR_APP_ID';
const appCertificate = 'YOUR_APP_CERTIFICATE';
const channelName = 'your-channel-name';
const uid = 0;
const role = Agora.RtcRole.PUBLISHER;
const expirationTimeInSeconds = 3600;

const currentTimestamp = Math.floor(Date.now() / 1000);
const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

const token = Agora.RtcTokenBuilder.buildTokenWithUid(
  appID,
  appCertificate,
  channelName,
  uid,
  role,
  privilegeExpiredTs
);

console.log(token);
```

### 2. 应用配置

#### 2.1 更新 App ID
编辑 `lib/video_call_screen.dart`：

```dart
await _engine.initialize(const RtcEngineContext(
  appId: 'YOUR_AGORA_APP_ID', // 替换为你的 Agora App ID
  channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
));
```

#### 2.2 配置 Token (可选)
```dart
await _engine.joinChannel(
  token: 'YOUR_TOKEN', // 从你的服务器获取的 Token
  channelId: widget.channelName,
  uid: 0,
  options: const ChannelMediaOptions(
    channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    clientRoleType: ClientRoleType.clientRoleBroadcaster,
  ),
);
```

## Android 部署

### 1. 构建配置

#### 1.1 生成签名密钥
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

#### 1.2 创建 key.properties
在 `android/` 目录下创建 `key.properties`：

```properties
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=upload
storeFile=/Users/yourusername/upload-keystore.jks
```

### 2. 构建 APK

```bash
# 调试版本
flutter build apk --debug

# 发布版本
flutter build apk --release
```

### 3. 构建 App Bundle (推荐)

```bash
flutter build appbundle --release
```

### 4. 发布到 Google Play Store

1. 登录 [Google Play Console](https://play.google.com/console/)
2. 创建新应用
3. 上传 App Bundle 文件
4. 填写应用信息
5. 提交审核

## iOS 部署

### 1. Xcode 配置

#### 1.1 打开项目
```bash
open ios/Runner.xcworkspace
```

#### 1.2 配置项目设置
1. 设置 Team: 在 Signing & Capabilities 中选择你的开发者账号
2. 设置 Bundle Identifier: 确保唯一性 (如 com.yourcompany.videochat)
3. 配置 Provisioning Profile

### 2. 构建应用

#### 2.1 命令行构建
```bash
# 调试版本
flutter build ios --debug

# 发布版本
flutter build ios --release
```

#### 2.2 Xcode 构建
1. 在 Xcode 中选择设备或模拟器
2. Product → Archive
3. 上传到 App Store Connect

### 3. 发布到 App Store

1. 登录 [App Store Connect](https://appstoreconnect.apple.com/)
2. 创建新应用
3. 配置应用信息
4. 上传构建版本
5. 提交审核

## 服务器配置 (推荐)

### 1. Token 服务器

#### Node.js 示例
```javascript
// server.js
const express = require('express');
const Agora = require('agora-access-token');
const cors = require('cors');

const app = express();
app.use(cors());

const APP_ID = 'YOUR_APP_ID';
const APP_CERTIFICATE = 'YOUR_APP_CERTIFICATE';

app.get('/token/:channelName/:uid', (req, res) => {
  const channelName = req.params.channelName;
  const uid = parseInt(req.params.uid);
  const role = Agora.RtcRole.PUBLISHER;
  const expirationTimeInSeconds = 3600;
  
  const currentTimestamp = Math.floor(Date.now() / 1000);
  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;
  
  const token = Agora.RtcTokenBuilder.buildTokenWithUid(
    APP_ID,
    APP_CERTIFICATE,
    channelName,
    uid,
    role,
    privilegeExpiredTs
  );
  
  res.json({ token });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

#### Python 示例
```python
# server.py
from flask import Flask, jsonify
from agora_token import RtcTokenBuilder, RtcRole
import os

app = Flask(__name__)

APP_ID = 'YOUR_APP_ID'
APP_CERTIFICATE = 'YOUR_APP_CERTIFICATE'

@app.route('/token/<channel_name>/<int:uid>')
def generate_token(channel_name, uid):
    role = RtcRole.PUBLISHER
    expiration_time_in_seconds = 3600
    
    current_timestamp = int(time.time())
    privilege_expired_ts = current_timestamp + expiration_time_in_seconds
    
    token = RtcTokenBuilder.build_token_with_uid(
        APP_ID,
        APP_CERTIFICATE,
        channel_name,
        uid,
        role,
        privilege_expired_ts
    )
    
    return jsonify({'token': token})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

### 2. 部署到云服务

#### Heroku 部署
```bash
# 安装 Heroku CLI
heroku login
heroku create your-app-name
git push heroku main
```

#### AWS 部署
```bash
# 使用 AWS Elastic Beanstalk
eb init
eb create production
eb deploy
```

## API 文档

### Agora RTC Engine 主要方法

#### 初始化
```dart
// 创建引擎实例
RtcEngine engine = createAgoraRtcEngine();

// 初始化引擎
await engine.initialize(RtcEngineContext(
  appId: 'YOUR_APP_ID',
  channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
));
```

#### 频道管理
```dart
// 加入频道
await engine.joinChannel(
  token: 'token',
  channelId: 'channel-name',
  uid: 0,
  options: ChannelMediaOptions(
    channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    clientRoleType: ClientRoleType.clientRoleBroadcaster,
  ),
);

// 离开频道
await engine.leaveChannel();

// 设置用户角色
await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
```

#### 媒体控制
```dart
// 启用视频
await engine.enableVideo();

// 开始预览
await engine.startPreview();

// 静音/取消静音
await engine.muteLocalAudioStream(true/false);

// 关闭/开启视频
await engine.muteLocalVideoStream(true/false);

// 切换摄像头
await engine.switchCamera();

// 设置扬声器
await engine.setEnableSpeakerphone(true/false);
```

#### 事件处理
```dart
engine.registerEventHandler(RtcEngineEventHandler(
  onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
    // 用户成功加入频道
  },
  onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
    // 远程用户加入
  },
  onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
    // 远程用户离开
  },
  onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
    // Token 即将过期，需要更新
  },
));
```

## 安全考虑

### 1. Token 认证
- 生产环境必须使用 Token
- 定期更新 Token
- 使用 HTTPS 传输 Token

### 2. 数据保护
- 不要在客户端硬编码 App Certificate
- 使用安全的服务器存储敏感信息
- 实现适当的访问控制

### 3. 网络安全
- 使用 HTTPS/WSS 协议
- 实现防火墙规则
- 监控异常流量

## 监控和日志

### 1. Agora 控制台
- 实时监控通话质量
- 查看使用统计
- 设置警报

### 2. 应用监控
```dart
// 启用调试日志
await engine.initialize(RtcEngineContext(
  appId: appId,
  channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
  areaCode: AreaCode.AREA_CODE_GLOBAL,
));
```

## 故障排除

### 常见问题

#### 1. 连接失败
- 检查 App ID 是否正确
- 确认网络连接
- 验证 Token 有效性

#### 2. 权限问题
- 确认相机和麦克风权限已授予
- 检查 AndroidManifest.xml 和 Info.plist 配置

#### 3. 视频质量问题
- 检查网络带宽
- 调整视频编码参数
- 考虑使用 Agora 的质量增强功能

### 调试工具
- Agora Web Inspector
- Flutter DevTools
- Xcode Console
- Android Logcat

## 联系支持

- [Agora 文档](https://docs.agora.io/en/)
- [Agora 社区](https://www.agora.io/en/community/)
- [Flutter 文档](https://flutter.dev/docs)