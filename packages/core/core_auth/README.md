# core_auth

认证层核心包，提供统一的用户认证和授权管理。

## 功能特性

- ✅ 用户登录/注册
- ✅ Token 管理（Access Token + Refresh Token）
- ✅ Token 自动刷新
- ✅ 用户信息管理
- ✅ 密码修改/重置
- ✅ JWT Token 解码
- ✅ 认证状态管理
- ✅ 安全存储（Token 加密存储）
- ✅ 用户信息缓存

## 安装

```yaml
dependencies:
  core_auth:
    path: ../core/core_auth
```

## 使用示例

### 1. 初始化

```dart
import 'package:core_auth/core_auth.dart';
import 'package:core_network/core_network.dart';

// 在main函数中初始化
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化存储服务
  await StorageService.init();
  await CacheManager.init();
  
  runApp(MyApp());
}

// 创建 AuthService
final apiClient = ApiClient(
  config: NetworkConfig(baseUrl: 'https://api.example.com'),
);
final authService = AuthService(apiClient: apiClient);
```

### 2. 用户登录

```dart
try {
  final token = await authService.login(
    username: 'user@sdu.edu.cn',
    password: 'password123',
  );
  
  print('登录成功: ${token.accessToken}');
  
  // 获取用户信息
  final user = await authService.getCurrentUser();
  print('欢迎: ${user.username}');
} catch (e) {
  print('登录失败: $e');
}
```

### 3. 用户注册

```dart
try {
  final token = await authService.register(
    username: 'newuser',
    email: 'newuser@sdu.edu.cn',
    password: 'password123',
  );
  
  print('注册成功');
} catch (e) {
  print('注册失败: $e');
}
```

### 4. 用户登出

```dart
await authService.logout();
print('已登出');
```

### 5. Token 管理

```dart
final tokenManager = TokenManager();

// 获取 Token
final token = await tokenManager.getToken();
if (token != null) {
  print('Access Token: ${token.accessToken}');
  print('过期时间: ${token.expiresAt}');
  print('是否过期: ${token.isExpired}');
  print('是否即将过期: ${token.isExpiringSoon}');
}

// 检查 Token 是否有效
final isValid = await tokenManager.isTokenValid();
print('Token 有效: $isValid');

// 删除 Token
await tokenManager.deleteToken();
```

### 6. 刷新 Token

```dart
try {
  final newToken = await authService.refreshToken();
  print('Token 刷新成功');
} catch (e) {
  print('Token 刷新失败: $e');
  // 需要重新登录
}
```

### 7. 获取用户信息

```dart
// 从缓存获取（如果有）
final user = await authService.getCurrentUser();
print('用户: ${user.username}');

// 强制从服务器刷新
final freshUser = await authService.getCurrentUser(forceRefresh: true);
```

### 8. 更新用户信息

```dart
try {
  final updatedUser = await authService.updateUser({
    'username': 'newusername',
    'avatar': 'https://example.com/new-avatar.jpg',
  });
  
  print('更新成功: ${updatedUser.username}');
} catch (e) {
  print('更新失败: $e');
}
```

### 9. 修改密码

```dart
try {
  await authService.changePassword(
    oldPassword: 'oldpassword',
    newPassword: 'newpassword',
  );
  
  print('密码修改成功');
} catch (e) {
  print('密码修改失败: $e');
}
```

### 10. 重置密码

```dart
try {
  await authService.resetPassword(email: 'user@sdu.edu.cn');
  print('重置密码邮件已发送');
} catch (e) {
  print('重置密码失败: $e');
}
```

### 11. 认证状态管理

```dart
import 'package:core_auth/core_auth.dart';

// 初始状态
const initialState = AuthState.initial();
print('未认证: ${initialState.isUnauthenticated}');

// 认证中状态
const authenticatingState = AuthState.authenticating();
print('认证中: ${authenticatingState.isAuthenticating}');

// 已认证状态
final authenticatedState = AuthState.authenticated(
  user: user,
  token: token,
);
print('已认证: ${authenticatedState.isAuthenticated}');

// 认证失败状态
const failedState = AuthState.failed('用户名或密码错误');
print('失败: ${failedState.errorMessage}');
```

### 12. JWT Token 解码

```dart
final tokenManager = TokenManager();

final accessToken = await tokenManager.getAccessToken();
if (accessToken != null) {
  // 解码 Token
  final payload = tokenManager.decodeToken(accessToken);
  print('Token 内容: $payload');
  
  // 获取过期时间
  final expirationDate = tokenManager.getTokenExpirationDate(accessToken);
  print('过期时间: $expirationDate');
  
  // 检查是否过期
  final isExpired = tokenManager.isJwtExpired(accessToken);
  print('是否过期: $isExpired');
}
```

### 13. 完整示例

```dart
class AuthRepository {
  final AuthService _authService;
  
  AuthRepository(this._authService);
  
  // 登录并获取用户信息
  Future<User> loginAndGetUser(String username, String password) async {
    // 登录
    await _authService.login(
      username: username,
      password: password,
    );
    
    // 获取用户信息
    return await _authService.getCurrentUser();
  }
  
  // 检查登录状态
  Future<bool> checkAuthStatus() async {
    return await _authService.isLoggedIn();
  }
  
  // 自动刷新 Token
  Future<void> autoRefreshToken() async {
    final tokenManager = TokenManager();
    
    // 检查 Token 是否即将过期
    if (await tokenManager.isTokenExpiringSoon()) {
      try {
        await _authService.refreshToken();
        print('Token 自动刷新成功');
      } catch (e) {
        print('Token 自动刷新失败: $e');
        // 需要重新登录
        await _authService.logout();
      }
    }
  }
}
```

## 数据模型

### User（用户模型）

```dart
class User {
  final String id;
  final String username;
  final String email;
  final String? avatar;
  final String? phone;
  final DateTime? createdAt;
  final Map<String, dynamic>? extra;
}
```

### AuthToken（认证令牌模型）

```dart
class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final String tokenType;
  
  bool get isExpired;
  bool get isExpiringSoon;
  Duration get remainingTime;
}
```

### AuthState（认证状态模型）

```dart
enum AuthStatus {
  unauthenticated,
  authenticated,
  authenticating,
  failed,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final AuthToken? token;
  final String? errorMessage;
  
  bool get isAuthenticated;
  bool get isAuthenticating;
  bool get isUnauthenticated;
  bool get isFailed;
}
```

## API 接口约定

AuthService 期望后端提供以下接口：

### 登录
- **POST** `/auth/login`
- Body: `{ "username": "...", "password": "..." }`
- Response: `{ "access_token": "...", "refresh_token": "...", "expires_in": 3600 }`

### 注册
- **POST** `/auth/register`
- Body: `{ "username": "...", "email": "...", "password": "..." }`
- Response: `{ "access_token": "...", "refresh_token": "...", "expires_in": 3600 }`

### 登出
- **POST** `/auth/logout`
- Headers: `Authorization: Bearer <token>`

### 刷新 Token
- **POST** `/auth/refresh`
- Body: `{ "refresh_token": "..." }`
- Response: `{ "access_token": "...", "refresh_token": "...", "expires_in": 3600 }`

### 获取用户信息
- **GET** `/auth/me`
- Headers: `Authorization: Bearer <token>`
- Response: `{ "id": "...", "username": "...", "email": "..." }`

### 更新用户信息
- **PUT** `/auth/me`
- Headers: `Authorization: Bearer <token>`
- Body: `{ "username": "...", "avatar": "..." }`

### 修改密码
- **POST** `/auth/change-password`
- Headers: `Authorization: Bearer <token>`
- Body: `{ "old_password": "...", "new_password": "..." }`

### 重置密码
- **POST** `/auth/reset-password`
- Body: `{ "email": "..." }`

## 注意事项

1. **初始化**: 必须在使用前初始化 StorageService 和 CacheManager
2. **Token 安全**: Access Token 存储在 SecureStorage 中（加密存储）
3. **自动刷新**: 建议在应用启动时检查 Token 是否即将过期并自动刷新
4. **错误处理**: 所有方法都可能抛出 ApiException，需要适当处理
5. **缓存策略**: 用户信息默认缓存 1 天，可以通过 forceRefresh 强制刷新

## 依赖

- core_network: 网络请求
- core_storage: 数据存储
- jwt_decoder: ^2.0.1 - JWT Token 解码
- flutter_riverpod: ^2.4.0 - 状态管理（可选）

## 许可证

MIT
