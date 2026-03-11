# Toolkit 包集成指南

本文档说明如何在 SDU-SNA 项目中集成和使用 Toolkit 包。

## 概述

项目集成了以下 Toolkit 包：

1. **log_kit** - 日志系统
2. **crash_reporter_kit** - 崩溃收集
3. **permission_kit** - 权限管理（按需使用）

所有 Toolkit 包都托管在 GitHub 上（账号：h1s97x），使用独立仓库架构。

## 已集成的包

### 1. log_kit (日志系统)

#### 功能特性

- 多级别日志（Debug、Info、Warning、Error）
- 文件日志（自动轮转，限制大小和数量）
- 远程日志上报
- 标签分类
- 性能优化（异步写入）

#### 配置

在 `lib/main.dart` 中已经配置了日志系统：

```dart
await ToolkitInitializer.initialize(
  enableFileLog: true,          // 启用文件日志
  enableRemoteLog: false,        // 是否启用远程日志
  remoteLogUrl: 'https://log.sdu.edu.cn/api/logs',
  appVersion: '0.1.0',
);
```

#### 使用方法

**方式1：通过 ToolkitInitializer（推荐）**

```dart
import 'package:sdu_sna_android/core/services/toolkit_initializer.dart';

// 记录普通日志
ToolkitInitializer.log('用户登录成功', tag: 'Auth');

// 记录错误日志
ToolkitInitializer.logError(
  '网络请求失败',
  tag: 'Network',
  error: error,
  stackTrace: stackTrace,
);
```

**方式2：通过 core_utils（推荐）**

```dart
import 'package:core_utils/core_utils.dart';

// core_utils 已经导出了 log_kit
// LogKit.debug('调试信息');
// LogKit.info('普通信息');
// LogKit.warning('警告信息');
// LogKit.error('错误信息', error: e, stackTrace: st);
```

**方式3：直接使用 log_kit**

```dart
import 'package:log_kit/log_kit.dart';

// LogKit.debug('调试信息', tag: 'MyTag');
// LogKit.info('普通信息', tag: 'MyTag');
// LogKit.warning('警告信息', tag: 'MyTag');
// LogKit.error('错误信息', tag: 'MyTag', error: e, stackTrace: st);
```

#### 日志文件位置

- **Android**: `/data/data/com.sdu.sna/files/logs/`
- **iOS**: `Documents/logs/`
- **Windows**: `AppData/Local/SDU-SNA/logs/`

#### 日志配置

```dart
// 在 ToolkitInitializer 中配置
await LogKit.init(
  level: kDebugMode ? LogLevel.debug : LogLevel.info,
  enableFileLog: true,
  enableRemoteLog: false,
  remoteUrl: 'https://log.sdu.edu.cn/api/logs',
  maxFileSize: 10 * 1024 * 1024,  // 10MB
  maxFileCount: 5,                 // 保留5个日志文件
);
```

### 2. crash_reporter_kit (崩溃收集)

#### 功能特性

- 自动捕获未处理的异常
- 崩溃信息收集（设备信息、应用版本、堆栈跟踪）
- 远程上报
- 本地缓存（网络不可用时）

#### 配置

在 `lib/main.dart` 中已经配置了崩溃收集：

```dart
// 使用 Zone 捕获所有未处理的异常
runZonedGuarded(
  () {
    runApp(MyApp());
  },
  (error, stackTrace) {
    ToolkitInitializer.reportCrash(error, stackTrace);
  },
);
```

#### 使用方法

**自动捕获**

应用中所有未处理的异常都会自动被捕获并上报。

**手动上报**

```dart
import 'package:sdu_sna_android/core/services/toolkit_initializer.dart';

try {
  // 可能抛出异常的代码
} catch (e, stackTrace) {
  // 手动上报崩溃
  await ToolkitInitializer.reportCrash(
    e,
    stackTrace,
    extras: {
      'userId': '12345',
      'action': 'login',
    },
  );
}
```

#### 崩溃报告内容

- 异常类型和消息
- 完整堆栈跟踪
- 设备信息（型号、系统版本、屏幕尺寸等）
- 应用信息（版本、构建号）
- 自定义附加信息

### 3. permission_kit (权限管理)

#### 功能特性

- 统一的权限请求接口
- 权限状态检查
- 跳转到系统设置
- 支持多种权限类型

#### 使用方法

**检查权限**

```dart
import 'package:permission_kit/permission_kit.dart';

// 检查相机权限
final hasPermission = await PermissionKit.check(PermissionType.camera);

if (!hasPermission) {
  // 请求权限
  final granted = await PermissionKit.request(PermissionType.camera);
  
  if (!granted) {
    // 权限被拒绝，提示用户
    showDialog(...);
  }
}
```

**请求多个权限**

```dart
final permissions = [
  PermissionType.camera,
  PermissionType.storage,
  PermissionType.location,
];

final results = await PermissionKit.requestMultiple(permissions);

if (results[PermissionType.camera] == PermissionStatus.granted) {
  // 相机权限已授予
}
```

**跳转到系统设置**

```dart
// 如果权限被永久拒绝，引导用户到设置页面
await PermissionKit.openSettings();
```

#### 支持的权限类型

- `camera` - 相机
- `storage` - 存储
- `location` - 位置
- `microphone` - 麦克风
- `contacts` - 通讯录
- `calendar` - 日历
- `photos` - 相册
- `notification` - 通知

## 启用 Toolkit 包

目前 Toolkit 包的代码已经集成，但被注释掉了（因为网络问题）。要启用它们：

### 步骤 1: 确保网络连接

确保可以访问 GitHub，或配置代理：

```bash
# 配置 Git 代理（如果需要）
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
```

### 步骤 2: 取消注释依赖

在各个 `pubspec.yaml` 文件中取消注释 Toolkit 包依赖：

**packages/core/core_utils/pubspec.yaml**:
```yaml
dependencies:
  log_kit:
    git:
      url: https://github.com/h1s97x/LogKit.git
      ref: main
```

**pubspec.yaml** (主应用):
```yaml
dependencies:
  crash_reporter_kit:
    git:
      url: https://github.com/h1s97x/CrashReporterKit.git
      ref: main
  permission_kit:
    git:
      url: https://github.com/h1s97x/PermissionKit.git
      ref: main
```

### 步骤 3: 取消注释代码

在以下文件中取消注释 Toolkit 相关代码：

1. `lib/core/services/toolkit_initializer.dart`
2. `packages/core/core_utils/lib/core_utils.dart`

### 步骤 4: 安装依赖

```bash
flutter pub get
```

## 最佳实践

### 1. 日志记录

**DO ✅**

```dart
// 使用有意义的标签
ToolkitInitializer.log('用户登录成功', tag: 'Auth');

// 记录关键操作
ToolkitInitializer.log('开始下载文件: $fileName', tag: 'Download');

// 记录错误时包含上下文
ToolkitInitializer.logError(
  '网络请求失败',
  tag: 'Network',
  error: error,
  stackTrace: stackTrace,
);
```

**DON'T ❌**

```dart
// 不要记录敏感信息
ToolkitInitializer.log('密码: $password', tag: 'Auth'); // ❌

// 不要在循环中大量记录
for (var item in items) {
  ToolkitInitializer.log('处理: $item', tag: 'Loop'); // ❌
}

// 不要记录过长的内容
ToolkitInitializer.log(veryLongString, tag: 'Data'); // ❌
```

### 2. 崩溃上报

**DO ✅**

```dart
// 在关键操作中使用 try-catch
try {
  await criticalOperation();
} catch (e, stackTrace) {
  ToolkitInitializer.reportCrash(e, stackTrace, extras: {
    'operation': 'criticalOperation',
    'userId': currentUserId,
  });
  rethrow; // 或者处理错误
}
```

**DON'T ❌**

```dart
// 不要捕获所有异常而不上报
try {
  await operation();
} catch (e) {
  // 什么都不做 ❌
}

// 不要上报预期的异常
try {
  final data = await fetchData();
} catch (e) {
  if (e is NetworkException) {
    // 这是预期的异常，不需要上报
    showErrorMessage();
  } else {
    // 未预期的异常才上报
    ToolkitInitializer.reportCrash(e, stackTrace);
  }
}
```

### 3. 权限请求

**DO ✅**

```dart
// 在使用前检查权限
Future<void> takePhoto() async {
  final hasPermission = await PermissionKit.check(PermissionType.camera);
  
  if (!hasPermission) {
    final granted = await PermissionKit.request(PermissionType.camera);
    if (!granted) {
      showPermissionDeniedDialog();
      return;
    }
  }
  
  // 执行拍照操作
  await camera.takePicture();
}

// 提供清晰的权限说明
Future<void> requestLocationPermission() async {
  // 先显示说明对话框
  final shouldRequest = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('需要位置权限'),
      content: Text('我们需要访问您的位置来提供附近的服务'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('取消'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('允许'),
        ),
      ],
    ),
  );
  
  if (shouldRequest == true) {
    await PermissionKit.request(PermissionType.location);
  }
}
```

**DON'T ❌**

```dart
// 不要在应用启动时请求所有权限
void main() async {
  await PermissionKit.requestMultiple([
    PermissionType.camera,
    PermissionType.storage,
    PermissionType.location,
    // ... ❌
  ]);
  runApp(MyApp());
}

// 不要在没有说明的情况下请求权限
await PermissionKit.request(PermissionType.camera); // ❌ 用户不知道为什么需要
```

## 故障排查

### 问题 1: 无法下载 Toolkit 包

**症状**: `flutter pub get` 失败，提示无法访问 GitHub

**解决方案**:
1. 检查网络连接
2. 配置 Git 代理
3. 使用本地开发模式（参考 `docs/toolkit_local_development.md`）

### 问题 2: 日志文件过大

**症状**: 应用占用存储空间过大

**解决方案**:
```dart
// 调整日志配置
await LogKit.init(
  maxFileSize: 5 * 1024 * 1024,  // 减小到 5MB
  maxFileCount: 3,                // 只保留 3 个文件
);
```

### 问题 3: 崩溃上报失败

**症状**: 崩溃没有被上报到服务器

**解决方案**:
1. 检查网络连接
2. 检查 API 地址是否正确
3. 查看本地缓存的崩溃报告
4. 检查服务器日志

## 相关文档

- [Toolkit 包列表](./toolkit_packages.md)
- [本地开发指南](./toolkit_local_development.md)
- [架构设计](./architecture.md)
- [开发路线图](./DEVELOPMENT_ROADMAP.md)

## 更新日志

- **2026-03-11**: 初始版本，集成 log_kit、crash_reporter_kit、permission_kit
