import 'package:core_network/core_network.dart';
import 'package:core_storage/core_storage.dart';
import 'models/user.dart';
import 'models/auth_token.dart';
import 'token_manager.dart';

/// 认证服务
class AuthService {
  final ApiClient _apiClient;
  final TokenManager _tokenManager;
  final CacheManager _cache;

  static const String _userCacheKey = 'current_user';

  AuthService({
    required ApiClient apiClient,
    TokenManager? tokenManager,
    CacheManager? cache,
  })  : _apiClient = apiClient,
        _tokenManager = tokenManager ?? TokenManager(),
        _cache = cache ?? CacheManager.instance;

  /// 登录
  Future<AuthToken> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (!response.isSuccess || response.data == null) {
        throw ApiException(
          type: ApiExceptionType.response,
          message: response.message ?? '登录失败',
        );
      }

      final token = AuthToken.fromJson(response.data!);
      await _tokenManager.saveToken(token);

      return token;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        type: ApiExceptionType.unknown,
        message: '登录失败: $e',
      );
    }
  }

  /// 注册
  Future<AuthToken> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (!response.isSuccess || response.data == null) {
        throw ApiException(
          type: ApiExceptionType.response,
          message: response.message ?? '注册失败',
        );
      }

      final token = AuthToken.fromJson(response.data!);
      await _tokenManager.saveToken(token);

      return token;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        type: ApiExceptionType.unknown,
        message: '注册失败: $e',
      );
    }
  }

  /// 登出
  Future<void> logout() async {
    try {
      // 调用后端登出接口（可选）
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // 忽略登出接口错误
    } finally {
      // 清除本地数据
      await _tokenManager.deleteToken();
      await _cache.remove(_userCacheKey);
    }
  }

  /// 刷新 Token
  Future<AuthToken> refreshToken() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null) {
        throw ApiException(
          type: ApiExceptionType.unknown,
          message: 'Refresh token 不存在',
        );
      }

      final response = await _apiClient.post(
        '/auth/refresh',
        data: {
          'refresh_token': refreshToken,
        },
      );

      if (!response.isSuccess || response.data == null) {
        throw ApiException(
          type: ApiExceptionType.response,
          message: response.message ?? '刷新 Token 失败',
        );
      }

      final token = AuthToken.fromJson(response.data!);
      await _tokenManager.saveToken(token);

      return token;
    } catch (e) {
      // 刷新失败，清除 Token
      await _tokenManager.deleteToken();
      if (e is ApiException) rethrow;
      throw ApiException(
        type: ApiExceptionType.unknown,
        message: '刷新 Token 失败: $e',
      );
    }
  }

  /// 获取当前用户信息
  Future<User> getCurrentUser({bool forceRefresh = false}) async {
    // 先从缓存获取
    if (!forceRefresh) {
      final cached = _cache.getCache<Map<String, dynamic>>(
        _userCacheKey,
        (json) => json as Map<String, dynamic>,
      );
      if (cached != null) {
        return User.fromJson(cached);
      }
    }

    // 从服务器获取
    try {
      final response = await _apiClient.get('/auth/me');

      if (!response.isSuccess || response.data == null) {
        throw ApiException(
          type: ApiExceptionType.response,
          message: response.message ?? '获取用户信息失败',
        );
      }

      final user = User.fromJson(response.data!);

      // 缓存用户信息（1天）
      await _cache.setCache(
        _userCacheKey,
        user.toJson(),
        duration: const Duration(days: 1),
      );

      return user;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        type: ApiExceptionType.unknown,
        message: '获取用户信息失败: $e',
      );
    }
  }

  /// 更新用户信息
  Future<User> updateUser(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/auth/me', data: data);

      if (!response.isSuccess || response.data == null) {
        throw ApiException(
          type: ApiExceptionType.response,
          message: response.message ?? '更新用户信息失败',
        );
      }

      final user = User.fromJson(response.data!);

      // 更新缓存
      await _cache.setCache(
        _userCacheKey,
        user.toJson(),
        duration: const Duration(days: 1),
      );

      return user;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        type: ApiExceptionType.unknown,
        message: '更新用户信息失败: $e',
      );
    }
  }

  /// 修改密码
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/change-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (!response.isSuccess) {
        throw ApiException(
          type: ApiExceptionType.response,
          message: response.message ?? '修改密码失败',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        type: ApiExceptionType.unknown,
        message: '修改密码失败: $e',
      );
    }
  }

  /// 重置密码
  Future<void> resetPassword({required String email}) async {
    try {
      final response = await _apiClient.post(
        '/auth/reset-password',
        data: {'email': email},
      );

      if (!response.isSuccess) {
        throw ApiException(
          type: ApiExceptionType.response,
          message: response.message ?? '重置密码失败',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        type: ApiExceptionType.unknown,
        message: '重置密码失败: $e',
      );
    }
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    return await _tokenManager.isTokenValid();
  }

  /// 获取当前 Token
  Future<AuthToken?> getToken() async {
    return await _tokenManager.getToken();
  }

  /// 获取 Access Token
  Future<String?> getAccessToken() async {
    return await _tokenManager.getAccessToken();
  }
}
