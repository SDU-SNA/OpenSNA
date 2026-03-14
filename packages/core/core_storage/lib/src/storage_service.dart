import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储服务
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  /// 获取单例
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// 初始化
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception(
          'StorageService not initialized. Call StorageService.init() first.');
    }
    return _prefs!;
  }

  // ==================== String ====================

  /// 保存字符串
  Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  /// 获取字符串
  String? getString(String key, {String? defaultValue}) {
    return _preferences.getString(key) ?? defaultValue;
  }

  // ==================== Int ====================

  /// 保存整数
  Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  /// 获取整数
  int? getInt(String key, {int? defaultValue}) {
    return _preferences.getInt(key) ?? defaultValue;
  }

  // ==================== Double ====================

  /// 保存浮点数
  Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  /// 获取浮点数
  double? getDouble(String key, {double? defaultValue}) {
    return _preferences.getDouble(key) ?? defaultValue;
  }

  // ==================== Bool ====================

  /// 保存布尔值
  Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  /// 获取布尔值
  bool? getBool(String key, {bool? defaultValue}) {
    return _preferences.getBool(key) ?? defaultValue;
  }

  // ==================== StringList ====================

  /// 保存字符串列表
  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  /// 获取字符串列表
  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  // ==================== 通用操作 ====================

  /// 检查键是否存在
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  /// 删除指定键
  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  /// 清空所有数据
  Future<bool> clear() async {
    return await _preferences.clear();
  }

  /// 获取所有键
  Set<String> getKeys() {
    return _preferences.getKeys();
  }
}
