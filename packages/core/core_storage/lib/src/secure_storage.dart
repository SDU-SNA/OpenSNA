import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全存储服务（用于敏感数据）
class SecureStorage {
  static SecureStorage? _instance;
  late final FlutterSecureStorage _storage;

  SecureStorage._() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  /// 获取单例
  static SecureStorage get instance {
    _instance ??= SecureStorage._();
    return _instance!;
  }

  /// 保存数据
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// 读取数据
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// 删除数据
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// 检查键是否存在
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// 清空所有数据
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// 获取所有键值对
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  // ==================== 常用数据存储 ====================

  /// 保存Token
  Future<void> saveToken(String token) async {
    await write('auth_token', token);
  }

  /// 获取Token
  Future<String?> getToken() async {
    return await read('auth_token');
  }

  /// 删除Token
  Future<void> deleteToken() async {
    await delete('auth_token');
  }

  /// 保存用户密码（加密存储）
  Future<void> savePassword(String password) async {
    await write('user_password', password);
  }

  /// 获取用户密码
  Future<String?> getPassword() async {
    return await read('user_password');
  }

  /// 删除用户密码
  Future<void> deletePassword() async {
    await delete('user_password');
  }
}
