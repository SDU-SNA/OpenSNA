import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core_storage/core_storage.dart';

void main() {
  group('StorageService Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await StorageService.init();
    });

    test('should save and get string', () async {
      final storage = StorageService.instance;

      await storage.setString('test_key', 'test_value');
      final value = storage.getString('test_key');

      expect(value, 'test_value');
    });

    test('should save and get int', () async {
      final storage = StorageService.instance;

      await storage.setInt('test_int', 42);
      final value = storage.getInt('test_int');

      expect(value, 42);
    });

    test('should save and get bool', () async {
      final storage = StorageService.instance;

      await storage.setBool('test_bool', true);
      final value = storage.getBool('test_bool');

      expect(value, true);
    });

    test('should save and get double', () async {
      final storage = StorageService.instance;

      await storage.setDouble('test_double', 3.14);
      final value = storage.getDouble('test_double');

      expect(value, 3.14);
    });

    test('should save and get string list', () async {
      final storage = StorageService.instance;

      await storage.setStringList('test_list', ['a', 'b', 'c']);
      final value = storage.getStringList('test_list');

      expect(value, ['a', 'b', 'c']);
    });

    test('should return default value when key not exists', () {
      final storage = StorageService.instance;

      final value = storage.getString('non_exist', defaultValue: 'default');

      expect(value, 'default');
    });

    test('should check if key exists', () async {
      final storage = StorageService.instance;

      await storage.setString('exist_key', 'value');

      expect(storage.containsKey('exist_key'), true);
      expect(storage.containsKey('non_exist_key'), false);
    });

    test('should remove key', () async {
      final storage = StorageService.instance;

      await storage.setString('remove_key', 'value');
      expect(storage.containsKey('remove_key'), true);

      await storage.remove('remove_key');
      expect(storage.containsKey('remove_key'), false);
    });

    test('should clear all data', () async {
      final storage = StorageService.instance;

      await storage.setString('key1', 'value1');
      await storage.setString('key2', 'value2');
      expect(storage.getKeys().length, 2);

      await storage.clear();
      expect(storage.getKeys().length, 0);
    });

    test('should get all keys', () async {
      final storage = StorageService.instance;

      await storage.setString('key1', 'value1');
      await storage.setString('key2', 'value2');

      final keys = storage.getKeys();
      expect(keys.contains('key1'), true);
      expect(keys.contains('key2'), true);
    });
  });

  group('CacheManager Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await CacheManager.init();
    });

    test('should save and get cache', () async {
      final cache = CacheManager.instance;

      await cache.setCache('test_cache', 'test_data');
      final data =
          cache.getCache<String>('test_cache', (json) => json as String);

      expect(data, 'test_data');
    });

    test('should return null for expired cache', () async {
      final cache = CacheManager.instance;

      // 设置一个立即过期的缓存
      await cache.setCache(
        'expired_cache',
        'test_data',
        duration: const Duration(milliseconds: 1),
      );

      // 等待过期
      await Future.delayed(const Duration(milliseconds: 10));

      final data =
          cache.getCache<String>('expired_cache', (json) => json as String);
      expect(data, null);
    });

    test('should save cache with custom duration', () async {
      final cache = CacheManager.instance;

      await cache.setCache(
        'custom_cache',
        'test_data',
        duration: const Duration(days: 1),
      );

      final data =
          cache.getCache<String>('custom_cache', (json) => json as String);
      expect(data, 'test_data');
    });

    test('should remove cache', () async {
      final cache = CacheManager.instance;

      await cache.setCache('remove_cache', 'test_data');
      expect(cache.getCache<String>('remove_cache', (json) => json as String),
          'test_data');

      await cache.remove('remove_cache');
      expect(cache.getCache<String>('remove_cache', (json) => json as String),
          null);
    });

    test('should clear all cache', () async {
      final cache = CacheManager.instance;

      await cache.setCache('cache1', 'data1');
      await cache.setCache('cache2', 'data2');

      await cache.clearAll();

      expect(cache.getCache<String>('cache1', (json) => json as String), null);
      expect(cache.getCache<String>('cache2', (json) => json as String), null);
    });

    test('should handle complex data types', () async {
      final cache = CacheManager.instance;

      final testData = {'name': 'test', 'value': 123};
      await cache.setCache('complex_cache', testData);

      final data = cache.getCache<Map<String, dynamic>>(
        'complex_cache',
        (json) => json as Map<String, dynamic>,
      );

      expect(data, testData);
    });
  });
}
