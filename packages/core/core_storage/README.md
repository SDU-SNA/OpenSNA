# core_storage

存储层核心包，提供统一的数据持久化和缓存管理。

## 功能特性

- ✅ SharedPreferences 封装
- ✅ 安全存储（FlutterSecureStorage）
- ✅ 缓存管理（带过期时间）
- ✅ 自动清理过期缓存
- ✅ 类型安全的API

## 安装

```yaml
dependencies:
  core_storage:
    path: ../core/core_storage
```

## 使用示例

### 1. 初始化

```dart
import 'package:core_storage/core_storage.dart';

// 在main函数中初始化
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化存储服务
  await StorageService.init();
  await CacheManager.init();
  
  runApp(MyApp());
}
```

### 2. 普通存储（StorageService）

```dart
final storage = StorageService.instance;

// 保存数据
await storage.setString('username', 'user@sdu.edu.cn');
await storage.setInt('age', 20);
await storage.setBool('isLogin', true);

// 读取数据
final username = storage.getString('username');
final age = storage.getInt('age', defaultValue: 0);
final isLogin = storage.getBool('isLogin', defaultValue: false);

// 删除数据
await storage.remove('username');

// 清空所有数据
await storage.clear();
```

### 3. 安全存储（SecureStorage）

用于存储敏感数据（Token、密码等）：

```dart
final secureStorage = SecureStorage.instance;

// 保存Token
await secureStorage.saveToken('your_token_here');

// 获取Token
final token = await secureStorage.getToken();

// 删除Token
await secureStorage.deleteToken();

// 保存密码
await secureStorage.savePassword('password123');

// 获取密码
final password = await secureStorage.getPassword();

// 自定义数据
await secureStorage.write('api_key', 'your_api_key');
final apiKey = await secureStorage.read('api_key');
```

### 4. 缓存管理（CacheManager）

带过期时间的缓存：

```dart
final cacheManager = CacheManager.instance;

// 保存缓存（默认7天过期）
await cacheManager.setCache('user_info', userInfo);

// 保存缓存（自定义过期时间）
await cacheManager.setCache(
  'news_list',
  newsList,
  duration: Duration(hours: 1),
);

// 获取缓存
final userInfo = cacheManager.getCache<Map<String, dynamic>>(
  'user_info',
  (json) => json as Map<String, dynamic>,
);

// 删除缓存
await cacheManager.remove('user_info');

// 清理过期缓存
await cacheManager.clearExpired();

// 清空所有缓存
await cacheManager.clearAll();
```

### 5. 完整示例

```dart
class UserRepository {
  final _storage = StorageService.instance;
  final _secureStorage = SecureStorage.instance;
  final _cache = CacheManager.instance;

  // 保存用户信息
  Future<void> saveUser(User user) async {
    // 保存到缓存（1天过期）
    await _cache.setCache(
      'current_user',
      user.toJson(),
      duration: Duration(days: 1),
    );
    
    // 保存用户ID到普通存储
    await _storage.setString('user_id', user.id);
    
    // 保存Token到安全存储
    await _secureStorage.saveToken(user.token);
  }

  // 获取用户信息
  Future<User?> getUser() async {
    // 先从缓存获取
    final cached = _cache.getCache<Map<String, dynamic>>(
      'current_user',
      (json) => json as Map<String, dynamic>,
    );
    
    if (cached != null) {
      return User.fromJson(cached);
    }
    
    // 缓存未命中，从网络获取
    return null;
  }

  // 清除用户数据
  Future<void> clearUser() async {
    await _cache.remove('current_user');
    await _storage.remove('user_id');
    await _secureStorage.deleteToken();
  }
}
```

## 存储选择指南

### StorageService（普通存储）
- ✅ 非敏感数据
- ✅ 用户设置
- ✅ 应用配置
- ✅ 简单的键值对

### SecureStorage（安全存储）
- ✅ Token
- ✅ 密码
- ✅ API密钥
- ✅ 其他敏感信息

### CacheManager（缓存）
- ✅ 网络请求结果
- ✅ 临时数据
- ✅ 需要过期的数据
- ✅ 可以重新获取的数据

## 注意事项

1. **初始化**: 必须在使用前调用 `init()` 方法
2. **安全存储**: SecureStorage 在某些设备上可能需要用户解锁
3. **缓存清理**: 建议定期调用 `clearExpired()` 清理过期缓存
4. **数据大小**: SharedPreferences 不适合存储大量数据

## 依赖

- shared_preferences: ^2.2.0
- flutter_secure_storage: ^9.0.0
- path_provider: ^2.1.0

## 许可证

MIT
