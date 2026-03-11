# SDU网管会APP - 快速开始指南

## 项目初始化

### 1. 创建Package结构

```bash
# 在项目根目录执行
mkdir -p packages/core packages/features packages/shared
```

### 2. 创建Core Packages

#### 2.1 创建 core_network
```bash
cd packages/core
flutter create --template=package core_network
cd core_network
```

编辑 `pubspec.yaml`:
```yaml
name: core_network
description: 网络请求核心包
version: 0.1.0
publish_to: none

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0
  dio_cookie_manager: ^3.1.0
  cookie_jar: ^4.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

#### 2.2 创建 core_storage
```bash
cd ../
flutter create --template=package core_storage
```

#### 2.3 创建 core_auth
```bash
flutter create --template=package core_auth
```

#### 2.4 创建 core_ui
```bash
flutter create --template=package core_ui
```

#### 2.5 创建 core_router
```bash
flutter create --template=package core_router
```

#### 2.6 创建 core_utils
```bash
flutter create --template=package core_utils
```

### 3. 创建Feature Packages

```bash
cd ../features
flutter create --template=package feature_network_service
flutter create --template=package feature_campus_info
flutter create --template=package feature_convenience
flutter create --template=package feature_academic
flutter create --template=package feature_community
flutter create --template=package feature_profile
```

### 4. 创建Shared Packages

```bash
cd ../shared
flutter create --template=package shared_widgets
flutter create --template=package shared_models
```

### 5. 更新主应用的 pubspec.yaml

```yaml
name: opensna
description: 山东大学网管会一站式服务应用
publish_to: 'none'
version: 0.1.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

platforms:
  android:
  windows:

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Core packages
  core_network:
    path: packages/core/core_network
  core_storage:
    path: packages/core/core_storage
  core_auth:
    path: packages/core/core_auth
  core_ui:
    path: packages/core/core_ui
  core_router:
    path: packages/core/core_router
  core_utils:
    path: packages/core/core_utils

  # Feature packages
  feature_network_service:
    path: packages/features/feature_network_service
  feature_campus_info:
    path: packages/features/feature_campus_info
  feature_convenience:
    path: packages/features/feature_convenience
  feature_academic:
    path: packages/features/feature_academic
  feature_community:
    path: packages/features/feature_community
  feature_profile:
    path: packages/features/feature_profile

  # Shared packages
  shared_widgets:
    path: packages/shared/shared_widgets
  shared_models:
    path: packages/shared/shared_models

  # 状态管理
  provider: ^6.1.0
  hooks_riverpod: ^2.4.0
  flutter_hooks: ^0.20.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  riverpod_lint: ^2.3.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
```

---

## 第一个Package示例: core_network

### 目录结构
```
core_network/
├── lib/
│   ├── src/
│   │   ├── api_client.dart
│   │   ├── api_response.dart
│   │   ├── api_exception.dart
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart
│   │   │   ├── log_interceptor.dart
│   │   │   └── error_interceptor.dart
│   │   └── network_config.dart
│   └── core_network.dart
├── test/
│   └── core_network_test.dart
├── pubspec.yaml
└── README.md
```

### 实现代码

#### lib/src/api_response.dart
```dart
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  bool get isSuccess => code == 200;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
    );
  }
}
```

#### lib/src/api_exception.dart
```dart
class ApiException implements Exception {
  final int code;
  final String message;
  final dynamic data;

  ApiException({
    required this.code,
    required this.message,
    this.data,
  });

  @override
  String toString() => 'ApiException: [$code] $message';
}
```

#### lib/src/api_client.dart
```dart
import 'package:dio/dio.dart';
import 'api_response.dart';
import 'api_exception.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
    ));
  }

  Dio get dio => _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJsonT,
  ) {
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(response.data, fromJsonT);
    } else {
      throw ApiException(
        code: response.statusCode ?? -1,
        message: response.statusMessage ?? 'Unknown error',
      );
    }
  }

  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(code: -1, message: '网络连接超时');
      case DioExceptionType.badResponse:
        return ApiException(
          code: error.response?.statusCode ?? -1,
          message: error.response?.statusMessage ?? '服务器错误',
        );
      case DioExceptionType.cancel:
        return ApiException(code: -1, message: '请求已取消');
      default:
        return ApiException(code: -1, message: '网络错误');
    }
  }
}
```

#### lib/core_network.dart
```dart
library core_network;

export 'src/api_client.dart';
export 'src/api_response.dart';
export 'src/api_exception.dart';
export 'src/network_config.dart';
export 'src/interceptors/auth_interceptor.dart';
export 'src/interceptors/log_interceptor.dart';
export 'src/interceptors/error_interceptor.dart';
```

---

## 第一个Feature示例: feature_network_service

### 目录结构
```
feature_network_service/
├── lib/
│   ├── src/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── network_account.dart
│   │   │   ├── repositories/
│   │   │   │   └── network_repository.dart
│   │   │   └── datasources/
│   │   │       └── network_api.dart
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── get_account_info.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── account_page.dart
│   │       ├── widgets/
│   │       │   └── account_card.dart
│   │       └── providers/
│   │           └── account_provider.dart
│   └── feature_network_service.dart
└── pubspec.yaml
```

### pubspec.yaml
```yaml
name: feature_network_service
description: 校园网络服务功能模块
version: 0.1.0
publish_to: none

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  
  # Core dependencies
  core_network:
    path: ../../core/core_network
  core_auth:
    path: ../../core/core_auth
  core_ui:
    path: ../../core/core_ui
  
  # State management
  hooks_riverpod: ^2.4.0
  flutter_hooks: ^0.20.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### 实现代码

#### lib/src/data/models/network_account.dart
```dart
class NetworkAccount {
  final String username;
  final double balance;
  final double usedTraffic;
  final double totalTraffic;
  final DateTime expireDate;

  NetworkAccount({
    required this.username,
    required this.balance,
    required this.usedTraffic,
    required this.totalTraffic,
    required this.expireDate,
  });

  factory NetworkAccount.fromJson(Map<String, dynamic> json) {
    return NetworkAccount(
      username: json['username'] as String,
      balance: (json['balance'] as num).toDouble(),
      usedTraffic: (json['used_traffic'] as num).toDouble(),
      totalTraffic: (json['total_traffic'] as num).toDouble(),
      expireDate: DateTime.parse(json['expire_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'balance': balance,
      'used_traffic': usedTraffic,
      'total_traffic': totalTraffic,
      'expire_date': expireDate.toIso8601String(),
    };
  }

  double get trafficUsagePercent => 
      totalTraffic > 0 ? (usedTraffic / totalTraffic) * 100 : 0;
}
```

#### lib/src/data/datasources/network_api.dart
```dart
import 'package:core_network/core_network.dart';
import '../models/network_account.dart';

class NetworkApi {
  final ApiClient _client;

  NetworkApi(this._client);

  Future<NetworkAccount> getAccountInfo() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/network/account',
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    if (response.isSuccess && response.data != null) {
      return NetworkAccount.fromJson(response.data!);
    } else {
      throw ApiException(
        code: response.code,
        message: response.message,
      );
    }
  }
}
```

#### lib/src/presentation/providers/account_provider.dart
```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/models/network_account.dart';
import '../../data/datasources/network_api.dart';

final accountProvider = FutureProvider<NetworkAccount>((ref) async {
  // 这里需要注入 NetworkApi
  // final api = ref.watch(networkApiProvider);
  // return api.getAccountInfo();
  
  // 临时返回模拟数据
  return NetworkAccount(
    username: 'test_user',
    balance: 50.0,
    usedTraffic: 15.5,
    totalTraffic: 50.0,
    expireDate: DateTime.now().add(const Duration(days: 30)),
  );
});
```

#### lib/src/presentation/pages/account_page.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/account_provider.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('网络账号'),
      ),
      body: accountAsync.when(
        data: (account) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '账号: ${account.username}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text('余额: ¥${account.balance.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    Text(
                      '流量: ${account.usedTraffic.toStringAsFixed(2)}GB / ${account.totalTraffic.toStringAsFixed(2)}GB',
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: account.trafficUsagePercent / 100,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '到期时间: ${account.expireDate.toString().split(' ')[0]}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('加载失败: $error'),
        ),
      ),
    );
  }
}
```

#### lib/feature_network_service.dart
```dart
library feature_network_service;

export 'src/data/models/network_account.dart';
export 'src/presentation/pages/account_page.dart';
export 'src/presentation/providers/account_provider.dart';
```

---

## 主应用集成

### lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:feature_network_service/feature_network_service.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '山大网管会',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('山大网管会'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.wifi),
            title: const Text('网络账号'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 运行项目

```bash
# 获取依赖
flutter pub get

# 运行Android
flutter run -d android

# 运行Windows
flutter run -d windows

# 构建APK
flutter build apk --release

# 构建Windows
flutter build windows --release
```

---

## 开发工作流

### 1. 开发新功能
1. 在对应的 feature package 中开发
2. 编写单元测试
3. 在主应用中集成测试
4. 提交代码

### 2. 修改Core包
1. 修改 core package
2. 运行所有依赖该包的测试
3. 更新版本号
4. 提交代码

### 3. 代码审查
1. 检查代码规范
2. 运行 `flutter analyze`
3. 运行测试 `flutter test`
4. 审查PR

---

## 常用命令

```bash
# 分析代码
flutter analyze

# 运行测试
flutter test

# 格式化代码
dart format .

# 清理缓存
flutter clean

# 更新依赖
flutter pub upgrade

# 生成代码（Riverpod）
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 下一步

1. 完善 core_network 的拦截器
2. 实现 core_auth 的认证逻辑
3. 开发 core_ui 的通用组件
4. 实现更多 feature 模块
5. 编写集成测试
6. 优化性能

---

## 参考资源

- [Flutter Package开发](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)
- [Riverpod文档](https://riverpod.dev/)
- [Dio文档](https://pub.dev/packages/dio)
- [项目架构文档](./architecture.md)
- [功能需求文档](./features.md)
