# SDU网管会APP - 通用工具包架构

## 概述

通用工具包（Toolkit Packages）是独立于业务的、可复用的技术组件，可以被多个项目使用。这些包应该：
- ✅ 功能通用，不依赖特定业务
- ✅ 可独立发布到pub.dev或私有仓库
- ✅ 有完善的文档和示例
- ✅ 支持多平台（Android、Windows、iOS等）

---

## 仓库结构

### 当前架构：独立仓库（已采用）

```
GitHub账号: h1s97x
独立仓库列表（使用帕斯卡命名法）：
├── HardwareInfoKit          # 硬件检测工具 ✅
├── NetworkDiagnosticKit     # 网络诊断工具 ✅
├── LogKit                   # 日志管理工具 ✅
├── CrashReporterKit         # 崩溃报告工具 ✅
├── SystemMonitorKit         # 系统监控工具 ✅
├── DeviceSecurityKit        # 设备安全检测 ✅
└── PermissionKit            # 权限管理工具 ✅
```

**仓库地址格式**：
- `https://github.com/h1s97x/HardwareInfoKit`
- `https://github.com/h1s97x/NetworkDiagnosticKit`
- `https://github.com/h1s97x/LogKit`
- 等等...

**优点**：
- ✅ 独立维护和版本控制
- ✅ 可以开源贡献给社区
- ✅ 其他项目可以直接使用
- ✅ 清晰的职责划分
- ✅ 便于CI/CD独立部署

---

## 通用工具包列表

### 1. hardware_info_kit（已有）
**功能**: 跨平台硬件信息获取

**特性**：
- CPU信息（型号、核心数、频率）
- 内存信息（总量、可用、使用率）
- GPU信息（型号、显存、驱动）
- 磁盘信息（容量、可用空间）
- 电池信息（电量、充电状态）
- 操作系统信息

**平台支持**: Android ✅, Windows ✅, iOS 🚧, Linux 🚧

**仓库**: 独立仓库（已有）

**引用方式**：
```yaml
dependencies:
  hardware_info_kit:
    git:
      url: https://github.com/h1s97x/HardwareInfoKit.git
      ref: v1.0.0
```

---

### 2. network_diagnostic_kit（新建）
**功能**: 网络诊断和测试工具

**特性**：
- 🌐 **网络连接检测**
  - 检测网络连通性
  - 检测网络类型（WiFi/移动数据/以太网）
  - 检测网络强度
  
- 🚀 **网络测速**
  - 下载速度测试
  - 上传速度测试
  - 延迟测试（Ping）
  - 抖动测试
  - 丢包率测试
  
- 🔍 **DNS诊断**
  - DNS解析测试
  - DNS服务器检测
  - DNS解析时间
  - 多DNS服务器对比
  
- 🛣️ **路由追踪**
  - Traceroute功能
  - 显示每一跳的延迟
  - 识别网络瓶颈
  
- 📊 **网络质量评分**
  - 综合评分（0-100）
  - 网络质量等级（优秀/良好/一般/差）
  - 问题诊断建议
  
- 🔌 **端口扫描**
  - 检测指定端口是否开放
  - 常用端口检测（80, 443, 22等）
  - 端口响应时间

**数据模型**：
```dart
// 网络连接信息
class NetworkConnectionInfo {
  final bool isConnected;
  final NetworkType type;  // wifi, mobile, ethernet, none
  final String? ssid;      // WiFi名称
  final int? signalStrength; // 信号强度 (0-100)
  final String? ipAddress;
  final String? gateway;
}

// 网速测试结果
class SpeedTestResult {
  final double downloadSpeed;  // Mbps
  final double uploadSpeed;    // Mbps
  final int ping;              // ms
  final double jitter;         // ms
  final double packetLoss;     // %
  final DateTime timestamp;
}

// DNS诊断结果
class DnsTestResult {
  final String domain;
  final String? resolvedIp;
  final int responseTime;      // ms
  final bool isSuccess;
  final String? errorMessage;
}

// 路由追踪结果
class TracerouteResult {
  final String destination;
  final List<TracerouteHop> hops;
  final bool isComplete;
}

class TracerouteHop {
  final int hopNumber;
  final String? ipAddress;
  final String? hostname;
  final int responseTime;      // ms
}

// 网络质量评分
class NetworkQualityScore {
  final int score;             // 0-100
  final QualityLevel level;    // excellent, good, fair, poor
  final Map<String, dynamic> metrics;
  final List<String> suggestions;
}
```

**使用示例**：
```dart
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

// 检测网络连接
final connection = await NetworkDiagnostic.checkConnection();
print('网络类型: ${connection.type}');
print('信号强度: ${connection.signalStrength}%');

// 网络测速
final speedTest = await NetworkDiagnostic.runSpeedTest(
  downloadUrl: 'https://speed.cloudflare.com/__down',
  uploadUrl: 'https://speed.cloudflare.com/__up',
);
print('下载速度: ${speedTest.downloadSpeed} Mbps');
print('上传速度: ${speedTest.uploadSpeed} Mbps');
print('延迟: ${speedTest.ping} ms');

// DNS测试
final dnsTest = await NetworkDiagnostic.testDns(
  domain: 'www.sdu.edu.cn',
  dnsServers: ['8.8.8.8', '114.114.114.114'],
);
for (var result in dnsTest) {
  print('DNS ${result.dnsServer}: ${result.responseTime}ms');
}

// 路由追踪
final traceroute = await NetworkDiagnostic.traceroute(
  destination: 'www.sdu.edu.cn',
  maxHops: 30,
);
for (var hop in traceroute.hops) {
  print('${hop.hopNumber}. ${hop.ipAddress} - ${hop.responseTime}ms');
}

// 网络质量评分
final quality = await NetworkDiagnostic.evaluateQuality();
print('网络评分: ${quality.score}/100');
print('质量等级: ${quality.level}');
print('建议: ${quality.suggestions.join(", ")}');

// Ping测试
final pingResult = await NetworkDiagnostic.ping(
  host: 'www.sdu.edu.cn',
  count: 10,
);
print('平均延迟: ${pingResult.averageTime}ms');
print('丢包率: ${pingResult.packetLoss}%');
```

**平台支持**: Android ✅, Windows ✅, iOS ✅, Linux ✅

**依赖**：
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  connectivity_plus: ^5.0.0
```

---

### 3. system_monitor_kit（新建）
**功能**: 实时系统资源监控

**特性**：
- 📊 **实时监控**
  - CPU使用率监控
  - 内存使用率监控
  - 磁盘I/O监控
  - 网络流量监控
  
- 📈 **历史数据**
  - 资源使用历史记录
  - 数据可视化支持
  - 导出CSV/JSON
  
- ⚠️ **阈值告警**
  - 自定义阈值
  - 超限通知
  - 告警历史
  
- 🔥 **热点分析**
  - 进程资源占用排行
  - 资源消耗趋势
  - 异常检测

**数据模型**：
```dart
// 系统资源快照
class SystemSnapshot {
  final DateTime timestamp;
  final CpuUsage cpu;
  final MemoryUsage memory;
  final DiskUsage disk;
  final NetworkUsage network;
}

class CpuUsage {
  final double usagePercent;     // 总使用率
  final List<double> coreUsage;  // 每个核心使用率
  final double temperature;      // 温度（如果支持）
}

class MemoryUsage {
  final int totalBytes;
  final int usedBytes;
  final int availableBytes;
  final double usagePercent;
}

class DiskUsage {
  final int readBytesPerSec;
  final int writeBytesPerSec;
  final double usagePercent;
}

class NetworkUsage {
  final int receivedBytesPerSec;
  final int sentBytesPerSec;
  final int totalReceived;
  final int totalSent;
}

// 监控配置
class MonitorConfig {
  final Duration interval;       // 采样间隔
  final int historySize;         // 历史记录数量
  final Map<String, double> thresholds; // 阈值配置
}
```

**使用示例**：
```dart
import 'package:system_monitor_kit/system_monitor_kit.dart';

// 创建监控器
final monitor = SystemMonitor(
  config: MonitorConfig(
    interval: Duration(seconds: 1),
    historySize: 60,
    thresholds: {
      'cpu': 80.0,
      'memory': 90.0,
    },
  ),
);

// 开始监控
monitor.start();

// 监听实时数据
monitor.snapshotStream.listen((snapshot) {
  print('CPU: ${snapshot.cpu.usagePercent}%');
  print('内存: ${snapshot.memory.usagePercent}%');
});

// 监听告警
monitor.alertStream.listen((alert) {
  print('告警: ${alert.type} - ${alert.message}');
});

// 获取历史数据
final history = monitor.getHistory(duration: Duration(minutes: 5));

// 停止监控
monitor.stop();

// 导出数据
final csv = await monitor.exportToCsv();
```

**平台支持**: Android ✅, Windows ✅, iOS ✅, Linux ✅

---

### 4. device_security_kit（新建）
**功能**: 设备安全检测和风险评估

**特性**：
- 🔒 **设备安全检测**
  - Root/越狱检测
  - 调试器检测
  - 模拟器检测
  - Hook框架检测
  
- 🛡️ **应用安全**
  - 签名验证
  - 完整性检查
  - 防篡改检测
  
- 📱 **设备信息**
  - 设备指纹
  - 设备唯一标识
  - 设备风险评分
  
- 🔐 **加密工具**
  - AES加密/解密
  - RSA加密/解密
  - Hash计算（MD5, SHA256等）

**数据模型**：
```dart
// 安全检测结果
class SecurityCheckResult {
  final bool isRooted;           // 是否Root/越狱
  final bool isEmulator;         // 是否模拟器
  final bool isDebuggable;       // 是否可调试
  final bool isHooked;           // 是否被Hook
  final int riskScore;           // 风险评分 (0-100)
  final RiskLevel riskLevel;     // 风险等级
  final List<String> threats;    // 检测到的威胁
}

// 设备指纹
class DeviceFingerprint {
  final String deviceId;
  final String androidId;        // Android
  final String idfv;             // iOS
  final String hardwareId;
  final Map<String, dynamic> attributes;
}
```

**使用示例**：
```dart
import 'package:device_security_kit/device_security_kit.dart';

// 安全检测
final security = await DeviceSecurity.checkSecurity();
print('Root状态: ${security.isRooted}');
print('风险评分: ${security.riskScore}/100');

// 获取设备指纹
final fingerprint = await DeviceSecurity.getFingerprint();
print('设备ID: ${fingerprint.deviceId}');

// 加密数据
final encrypted = await DeviceSecurity.encrypt(
  data: 'sensitive data',
  key: 'encryption_key',
);

// 解密数据
final decrypted = await DeviceSecurity.decrypt(
  data: encrypted,
  key: 'encryption_key',
);
```

**平台支持**: Android ✅, Windows ✅, iOS ✅

---

### 5. performance_analyzer_kit（新建）
**功能**: 应用性能分析和优化建议

**特性**：
- ⚡ **性能指标**
  - FPS监控
  - 帧渲染时间
  - 内存泄漏检测
  - 卡顿检测
  
- 📊 **性能报告**
  - 性能评分
  - 瓶颈分析
  - 优化建议
  
- 🎯 **性能追踪**
  - 方法耗时追踪
  - 网络请求追踪
  - 数据库操作追踪

**数据模型**：
```dart
// 性能快照
class PerformanceSnapshot {
  final double fps;
  final double frameTime;        // ms
  final int memoryUsage;         // bytes
  final int jankCount;           // 卡顿次数
  final DateTime timestamp;
}

// 性能报告
class PerformanceReport {
  final int score;               // 0-100
  final double averageFps;
  final double averageFrameTime;
  final List<String> bottlenecks;
  final List<String> suggestions;
}
```

**使用示例**：
```dart
import 'package:performance_analyzer_kit/performance_analyzer_kit.dart';

// 开始性能监控
PerformanceAnalyzer.start();

// 监听FPS
PerformanceAnalyzer.fpsStream.listen((fps) {
  print('FPS: $fps');
});

// 追踪方法性能
await PerformanceAnalyzer.trace('loadData', () async {
  // 执行耗时操作
  await loadData();
});

// 生成性能报告
final report = await PerformanceAnalyzer.generateReport();
print('性能评分: ${report.score}/100');
print('优化建议: ${report.suggestions}');

// 停止监控
PerformanceAnalyzer.stop();
```

**平台支持**: Android ✅, Windows ✅, iOS ✅

---

### 6. log_kit（新建）
**功能**: 统一日志管理和上报

**特性**：
- 📝 **日志记录**
  - 多级别日志（Debug, Info, Warning, Error）
  - 结构化日志
  - 日志过滤
  
- 💾 **日志存储**
  - 本地文件存储
  - 日志轮转
  - 日志压缩
  
- 📤 **日志上报**
  - 远程日志上报
  - 批量上报
  - 离线缓存

**使用示例**：
```dart
import 'package:log_kit/log_kit.dart';

// 初始化
LogKit.init(
  level: LogLevel.debug,
  enableFileLog: true,
  enableRemoteLog: true,
  remoteUrl: 'https://log.sdu.edu.cn/api/logs',
);

// 记录日志
LogKit.d('Debug message');
LogKit.i('Info message');
LogKit.w('Warning message');
LogKit.e('Error message', error: exception, stackTrace: stack);

// 结构化日志
LogKit.event('user_login', data: {
  'userId': '123',
  'timestamp': DateTime.now().toIso8601String(),
});

// 导出日志
final logs = await LogKit.exportLogs();
```

**平台支持**: Android ✅, Windows ✅, iOS ✅, Linux ✅

---

### 7. crash_reporter_kit（新建）
**功能**: 崩溃收集和分析

**特性**：
- 💥 **崩溃捕获**
  - Flutter异常捕获
  - Native崩溃捕获
  - 未捕获异常处理
  
- 📊 **崩溃报告**
  - 堆栈信息
  - 设备信息
  - 应用状态
  
- 📤 **自动上报**
  - 崩溃自动上报
  - 符号化处理
  - 崩溃统计

**使用示例**：
```dart
import 'package:crash_reporter_kit/crash_reporter_kit.dart';

// 初始化
CrashReporter.init(
  apiUrl: 'https://crash.sdu.edu.cn/api/report',
  appVersion: '1.0.0',
);

// 自动捕获所有异常
runZonedGuarded(() {
  runApp(MyApp());
}, (error, stack) {
  CrashReporter.report(error, stack);
});

// 手动上报
try {
  // 危险操作
} catch (e, stack) {
  CrashReporter.report(e, stack);
}
```

**平台支持**: Android ✅, Windows ✅, iOS ✅

---

## 工具包开发规范

### 目录结构模板

```
toolkit_name/
├── lib/
│   ├── src/
│   │   ├── models/           # 数据模型
│   │   ├── enums/            # 枚举
│   │   ├── exceptions/       # 异常类
│   │   ├── utils/            # 工具类
│   │   └── platform/         # 平台特定实现
│   │       ├── android/
│   │       ├── ios/
│   │       └── windows/
│   └── toolkit_name.dart     # 主导出文件
├── android/                  # Android原生代码
├── ios/                      # iOS原生代码
├── windows/                  # Windows原生代码
├── example/                  # 示例应用
├── test/                     # 单元测试
├── doc/                      # 文档
│   ├── API.md
│   ├── ARCHITECTURE.md
│   └── USAGE_GUIDE.md
├── pubspec.yaml
├── README.md
├── README_EN.md
├── CHANGELOG.md
├── LICENSE
└── CONTRIBUTING.md
```

### pubspec.yaml模板

```yaml
name: toolkit_name
description: 工具包描述
version: 1.0.0
homepage: https://github.com/h1s97x/ToolkitName
repository: https://github.com/h1s97x/ToolkitName

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.3.0"

dependencies:
  flutter:
    sdk: flutter
  plugin_platform_interface: ^2.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  plugin:
    platforms:
      android:
        package: com.sdu.toolkit_name
        pluginClass: ToolkitNamePlugin
      ios:
        pluginClass: ToolkitNamePlugin
      windows:
        pluginClass: ToolkitNamePlugin
```

### 命名规范

- **仓库名**: `PascalCase` + `Kit` 后缀 (如: `NetworkDiagnosticKit`)
- **Package名**: `snake_case` + `_kit` 后缀 (如: `network_diagnostic_kit`)
- **类名**: `PascalCase` (如: `NetworkDiagnostic`)
- **方法名**: `camelCase` (如: `runSpeedTest`)
- **常量**: `lowerCamelCase` (如: `defaultTimeout`)

**示例对应关系**：
| 仓库名 | Package名 | 主类名 |
|--------|-----------|--------|
| HardwareInfoKit | hardware_info_kit | HardwareInfo |
| NetworkDiagnosticKit | network_diagnostic_kit | NetworkDiagnostic |
| LogKit | log_kit | LogKit |
| CrashReporterKit | crash_reporter_kit | CrashReporter |
| SystemMonitorKit | system_monitor_kit | SystemMonitor |
| DeviceSecurityKit | device_security_kit | DeviceSecurity |
| PermissionKit | permission_kit | PermissionManager |

### 文档要求

每个工具包必须包含：
1. README.md（中文）
2. README_EN.md（英文）
3. API.md（API文档）
4. USAGE_GUIDE.md（使用指南）
5. CHANGELOG.md（更新日志）
6. 完整的代码注释

### 测试要求

- 单元测试覆盖率 > 80%
- 集成测试覆盖核心功能
- 性能测试（如果涉及性能）
- 多平台测试

---

## 在主项目中使用

### 方式一：Git依赖（推荐）

```yaml
# pubspec.yaml
dependencies:
  hardware_info_kit:
    git:
      url: https://github.com/h1s97x/HardwareInfoKit.git
      ref: main  # 或特定tag
      
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: v1.0.0
      
  log_kit:
    git:
      url: https://github.com/h1s97x/LogKit.git
      ref: v1.0.0
      
  crash_reporter_kit:
    git:
      url: https://github.com/h1s97x/CrashReporterKit.git
      ref: v1.0.0
      
  system_monitor_kit:
    git:
      url: https://github.com/h1s97x/SystemMonitorKit.git
      ref: v1.0.0
      
  device_security_kit:
    git:
      url: https://github.com/h1s97x/DeviceSecurityKit.git
      ref: v1.0.0
      
  permission_kit:
    git:
      url: https://github.com/h1s97x/PermissionKit.git
      ref: v1.0.0
```

### 方式二：本地路径（本地开发）

```yaml
# pubspec.yaml
dependencies:
  hardware_info_kit:
    path: ../HardwareInfoKit
    
  network_diagnostic_kit:
    path: ../NetworkDiagnosticKit
```

### 方式三：pub.dev（发布后）

```yaml
# pubspec.yaml
dependencies:
  hardware_info_kit: ^1.0.0
  network_diagnostic_kit: ^1.0.0
```

---

## 集成到主应用

### 创建工具包管理器

```dart
// lib/core/toolkit/toolkit_manager.dart
import 'package:hardware_info_kit/hardware_info_kit.dart';
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';
import 'package:system_monitor_kit/system_monitor_kit.dart';

class ToolkitManager {
  static ToolkitManager? _instance;
  
  factory ToolkitManager() {
    _instance ??= ToolkitManager._();
    return _instance!;
  }
  
  ToolkitManager._();
  
  // 硬件信息
  Future<SystemInfo> getHardwareInfo() async {
    return await HardwareInfo.getSystemInfo();
  }
  
  // 网络诊断
  Future<SpeedTestResult> runSpeedTest() async {
    return await NetworkDiagnostic.runSpeedTest();
  }
  
  // 系统监控
  SystemMonitor createSystemMonitor() {
    return SystemMonitor(
      config: MonitorConfig(
        interval: Duration(seconds: 1),
        historySize: 60,
      ),
    );
  }
}
```

### 在功能模块中使用

```dart
// packages/features/feature_network_service/lib/src/presentation/pages/diagnostic_page.dart
import 'package:flutter/material.dart';
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

class NetworkDiagnosticPage extends StatefulWidget {
  @override
  _NetworkDiagnosticPageState createState() => _NetworkDiagnosticPageState();
}

class _NetworkDiagnosticPageState extends State<NetworkDiagnosticPage> {
  SpeedTestResult? _speedTestResult;
  bool _isLoading = false;
  
  Future<void> _runSpeedTest() async {
    setState(() => _isLoading = true);
    
    try {
      final result = await NetworkDiagnostic.runSpeedTest();
      setState(() {
        _speedTestResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // 错误处理
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('网络诊断')),
      body: Column(
        children: [
          if (_isLoading)
            CircularProgressIndicator()
          else if (_speedTestResult != null)
            _buildResult(_speedTestResult!),
          ElevatedButton(
            onPressed: _runSpeedTest,
            child: Text('开始测速'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildResult(SpeedTestResult result) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('下载速度: ${result.downloadSpeed.toStringAsFixed(2)} Mbps'),
            Text('上传速度: ${result.uploadSpeed.toStringAsFixed(2)} Mbps'),
            Text('延迟: ${result.ping} ms'),
          ],
        ),
      ),
    );
  }
}
```

---

## 开发优先级

### Phase 1: 核心工具（立即开发）
1. ✅ hardware_info_kit（已完成）
2. 🔨 network_diagnostic_kit（高优先级）
3. 🔨 log_kit（高优先级）

### Phase 2: 监控工具（v1.0）
4. system_monitor_kit
5. performance_analyzer_kit

### Phase 3: 安全工具（v1.5）
6. device_security_kit
7. crash_reporter_kit

---

## 发布流程

### 1. 开发完成
- 完成所有功能
- 通过所有测试
- 完善文档

### 2. 版本发布
```bash
# 更新版本号
# 编辑 pubspec.yaml 和 CHANGELOG.md

# 提交代码
git add .
git commit -m "chore: release v1.0.0"
git tag v1.0.0
git push origin main --tags
```

### 3. 发布到pub.dev（可选）
```bash
# 检查发布准备
flutter pub publish --dry-run

# 发布
flutter pub publish
```

### 4. 在主项目中更新
```yaml
# 更新到新版本
dependencies:
  network_diagnostic_kit: ^1.0.0
```

---

## 维护策略

### 版本管理
- 遵循语义化版本（Semantic Versioning）
- 主版本：不兼容的API修改
- 次版本：向下兼容的功能新增
- 修订版本：向下兼容的bug修复

### 更新频率
- 核心工具包：每月检查更新
- 安全相关：及时更新
- 性能优化：按需更新

### 兼容性
- 保持向下兼容
- 废弃API提前通知（至少一个大版本）
- 提供迁移指南

---

## 总结

通用工具包的优势：
1. ✅ 代码复用，减少重复开发
2. ✅ 独立维护，不影响主项目
3. ✅ 可以开源贡献社区
4. ✅ 其他项目可以直接使用
5. ✅ 专注于技术实现，不涉及业务

建议：
- 优先开发 `network_diagnostic_kit`（网管会核心需求）
- `hardware_info_kit` 已经很完善，可以直接使用
- 其他工具包根据需求逐步开发
- 考虑开源到GitHub，提升影响力
