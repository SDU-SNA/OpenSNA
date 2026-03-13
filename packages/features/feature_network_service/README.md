# feature_network_service

网络服务功能模块，提供网络账号管理、在线设备管理、网络测速和故障报修等功能。

## 功能特性

### 1. 网络账号管理
- 余额查询
- 流量统计
- 套餐信息
- 使用历史

### 2. 在线设备管理
- 设备列表查询
- 设备详情查看
- 设备下线操作
- 设备统计

### 3. 网络测速
- 下载速度测试
- 上传速度测试
- 延迟测试
- 测速历史记录

### 4. 故障报修
- 报修表单提交
- 图片上传
- 报修记录查询
- 维修进度跟踪

## 架构设计

采用 Clean Architecture 分层架构：

```
lib/
├── src/
│   ├── data/                    # 数据层
│   │   ├── models/              # 数据模型
│   │   ├── datasources/         # 数据源
│   │   └── repositories/        # Repository 实现
│   ├── domain/                  # 领域层
│   │   ├── entities/            # 实体
│   │   └── usecases/            # 用例
│   └── presentation/            # 表现层
│       ├── pages/               # 页面
│       ├── widgets/             # 组件
│       └── providers/           # 状态管理
└── feature_network_service.dart # 主导出文件
```

## 使用示例

### 1. 网络账号管理

```dart
import 'package:feature_network_service/feature_network_service.dart';

// 查询网络账号信息
final accountProvider = ref.watch(networkAccountProvider);

accountProvider.when(
  data: (account) => Text('余额: ${account.balance}元'),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('加载失败: $error'),
);
```

### 2. 在线设备管理

```dart
// 查询在线设备列表
final devicesProvider = ref.watch(onlineDevicesProvider);

devicesProvider.when(
  data: (devices) => ListView.builder(
    itemCount: devices.length,
    itemBuilder: (context, index) {
      final device = devices[index];
      return DeviceListItem(device: device);
    },
  ),
  loading: () => LoadingWidget(),
  error: (error, stack) => ErrorWidget(error: error),
);

// 下线设备
await ref.read(deviceManageProvider.notifier).offlineDevice(deviceId);
```

### 3. 网络测速

```dart
// 开始测速
final speedTestProvider = ref.watch(networkSpeedTestProvider);

// 监听测速进度
speedTestProvider.when(
  data: (result) => SpeedTestResult(result: result),
  loading: () => SpeedTestProgress(),
  error: (error, stack) => ErrorWidget(error: error),
);

// 查看测速历史
final historyProvider = ref.watch(speedTestHistoryProvider);
```

### 4. 故障报修

```dart
// 提交报修
final repairProvider = ref.read(repairServiceProvider.notifier);

await repairProvider.submitRepair(
  title: '网络无法连接',
  description: '宿舍网络突然断开，无法连接',
  images: [File('path/to/image.jpg')],
  location: '东校区1号楼101',
);

// 查询报修记录
final recordsProvider = ref.watch(repairRecordsProvider);
```

## 依赖

### Core 层
- core_network: 网络请求
- core_storage: 数据存储
- core_ui: UI 组件
- core_router: 路由管理
- core_utils: 工具类

### Toolkit 包
- network_diagnostic_kit: 网络诊断工具

### 第三方库
- flutter_riverpod: 状态管理
- cached_network_image: 图片缓存
- intl: 国际化

## 开发指南

### 添加新功能

1. 在 `data/models/` 创建数据模型
2. 在 `data/datasources/` 创建数据源
3. 在 `data/repositories/` 实现 Repository
4. 在 `domain/usecases/` 创建用例
5. 在 `presentation/providers/` 创建 Provider
6. 在 `presentation/pages/` 创建页面
7. 在 `presentation/widgets/` 创建组件

### 运行测试

```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/data/repositories/network_repository_test.dart
```

### 代码生成

```bash
# 生成 Riverpod 和 JSON 序列化代码
flutter pub run build_runner build --delete-conflicting-outputs
```

## 注意事项

1. 所有网络请求都通过 core_network 的 ApiClient
2. 敏感数据（如 Token）使用 core_storage 的 SecureStorage
3. 遵循 Clean Architecture 原则
4. 使用 Riverpod 进行状态管理
5. 所有 UI 组件使用 Material Design 3

## 版本历史

### v0.1.0 (2026-03-11)
- 初始版本
- 网络账号管理功能
- 在线设备管理功能
- 网络测速功能（集成 network_diagnostic_kit）
- 故障报修功能

## 许可证

MIT License
