library core_auth;

// 服务
export 'src/auth_service.dart';
export 'src/token_manager.dart';

// 模型
export 'src/models/user.dart';
export 'src/models/auth_token.dart';
export 'src/models/auth_state.dart';

// 依赖导出（方便使用）
export 'package:core_network/core_network.dart' show ApiClient, ApiException;
export 'package:core_storage/core_storage.dart' show SecureStorage, StorageService, CacheManager;
