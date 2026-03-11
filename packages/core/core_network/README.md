# core_network

网络层核心包，提供统一的网络请求、拦截器和错误处理。

## 功能特性

- ✅ 统一的API请求封装
- ✅ 自动Token管理
- ✅ 请求/响应日志（使用log_kit）
- ✅ 统一错误处理
- ✅ Cookie管理
- ✅ 文件上传/下载
- ✅ 请求取消
- ✅ 进度回调

## 安装

```yaml
dependencies:
  core_network:
    path: ../core/core_network
```

## 使用示例

### 1. 初始化

```dart
import 'package:core_network/core_network.dart';

// 创建API客户端
final apiClient = ApiClient(
  config: NetworkConfig.development(),
  getToken: () async {
    // 返回当前Token
    return await StorageService().getToken();
  },
);
```

### 2. GET请求

```dart
// 简单GET请求
final response = await apiClient.get('/api/user/info');
if (response.isSuccess) {
  print(response.data);
}

// 带参数的GET请求
final response = await apiClient.get(
  '/api/users',
  queryParameters: {'page': 1, 'size': 20},
);

// 带类型转换的GET请求
final response = await apiClient.get<User>(
  '/api/user/info',
  fromJsonT: (json) => User.fromJson(json),
);
```

### 3. POST请求

```dart
// POST请求
final response = await apiClient.post(
  '/api/login',
  data: {
    'username': 'user@sdu.edu.cn',
    'password': 'password123',
  },
);
```

### 4. 文件上传

```dart
// 上传文件
final formData = FormData.fromMap({
  'file': await MultipartFile.fromFile(
    filePath,
    filename: 'image.jpg',
  ),
  'description': '图片描述',
});

final response = await apiClient.upload(
  '/api/upload',
  formData,
  onSendProgress: (sent, total) {
    print('上传进度: ${(sent / total * 100).toStringAsFixed(0)}%');
  },
);
```

### 5. 文件下载

```dart
// 下载文件
await apiClient.download(
  '/api/files/document.pdf',
  '/path/to/save/document.pdf',
  onReceiveProgress: (received, total) {
    print('下载进度: ${(received / total * 100).toStringAsFixed(0)}%');
  },
);
```

### 6. 错误处理

```dart
try {
  final response = await apiClient.get('/api/data');
  // 处理成功响应
} on ApiException catch (e) {
  // 处理API异常
  switch (e.type) {
    case ApiExceptionType.connectTimeout:
      print('连接超时');
      break;
    case ApiExceptionType.response:
      print('服务器错误: ${e.code} - ${e.message}');
      break;
    default:
      print('未知错误: ${e.message}');
  }
}
```

## 配置

### 网络配置

```dart
// 开发环境
final config = NetworkConfig.development();

// 生产环境
final config = NetworkConfig.production();

// 自定义配置
final config = NetworkConfig(
  baseUrl: 'https://api.example.com',
  connectTimeout: 30000,
  receiveTimeout: 30000,
  sendTimeout: 30000,
  enableLog: true,
  enableCookie: true,
);
```

## API响应格式

默认期望的响应格式：

```json
{
  "code": 200,
  "message": "success",
  "data": {},
  "timestamp": 1234567890
}
```

## 依赖

- dio: ^5.4.0
- dio_cookie_manager: ^3.1.0
- cookie_jar: ^4.0.8
- log_kit: 日志管理（Toolkit包）

## 许可证

MIT
