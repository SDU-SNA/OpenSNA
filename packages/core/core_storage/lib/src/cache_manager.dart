import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 缓存项
class CacheItem<T> {
  final T data;
  final DateTime expireTime;

  CacheItem({
    required this.data,
    required this.expireTime,
  });

  bool get isExpired => DateTime.now().isAfter(expireTime);

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'expireTime': expireTime.millisecondsSinceEpoch,
    };
  }

  factory CacheItem.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return CacheItem<T>(
      data: fromJsonT(json['data']),
      expireTime: DateTime.fromMillisecondsSinceEpoch(json['expireTime']),
    );
  }
}

/// 缓存管理器
class CacheManager {
  static CacheManager? _instance;
  static SharedPreferences? _prefs;

  CacheManager._();

  static CacheManager get instance {
    _instance ??= CacheManager._();
    return _instance!;
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception(
          'CacheManager not initialized. Call CacheManager.init() first.');
    }
    return _prefs!;
  }

  /// 保存缓存
  Future<bool> setCache<T>(
    String key,
    T data, {
    Duration? duration,
  }) async {
    final expireTime = duration != null
        ? DateTime.now().add(duration)
        : DateTime.now().add(const Duration(days: 7)); // 默认7天

    final cacheItem = CacheItem<T>(
      data: data,
      expireTime: expireTime,
    );

    final jsonString = jsonEncode(cacheItem.toJson());
    return await _preferences.setString(_getCacheKey(key), jsonString);
  }

  /// 获取缓存
  T? getCache<T>(
    String key,
    T Function(dynamic) fromJsonT,
  ) {
    final jsonString = _preferences.getString(_getCacheKey(key));
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString);
      final cacheItem = CacheItem<T>.fromJson(json, fromJsonT);

      // 检查是否过期
      if (cacheItem.isExpired) {
        remove(key);
        return null;
      }

      return cacheItem.data;
    } catch (e) {
      // 解析失败，删除缓存
      remove(key);
      return null;
    }
  }

  /// 删除缓存
  Future<bool> remove(String key) async {
    return await _preferences.remove(_getCacheKey(key));
  }

  /// 清空所有缓存
  Future<bool> clearAll() async {
    final keys = _preferences
        .getKeys()
        .where((key) => key.startsWith('cache_'))
        .toList();

    for (final key in keys) {
      await _preferences.remove(key);
    }
    return true;
  }

  /// 清理过期缓存
  Future<void> clearExpired() async {
    final keys = _preferences
        .getKeys()
        .where((key) => key.startsWith('cache_'))
        .toList();

    for (final key in keys) {
      final jsonString = _preferences.getString(key);
      if (jsonString != null) {
        try {
          final json = jsonDecode(jsonString);
          final expireTime =
              DateTime.fromMillisecondsSinceEpoch(json['expireTime']);
          if (DateTime.now().isAfter(expireTime)) {
            await _preferences.remove(key);
          }
        } catch (e) {
          // 解析失败，删除
          await _preferences.remove(key);
        }
      }
    }
  }

  String _getCacheKey(String key) => 'cache_$key';
}
