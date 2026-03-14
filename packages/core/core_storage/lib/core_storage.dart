library core_storage;

// 存储服务
export 'src/storage_service.dart';
export 'src/secure_storage.dart';
export 'src/cache_manager.dart';

// 导出依赖（方便使用）
export 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
export 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;
