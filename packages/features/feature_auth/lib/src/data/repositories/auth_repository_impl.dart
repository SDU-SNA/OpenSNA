import 'package:core_auth/core_auth.dart';
import 'package:core_network/core_network.dart';
import '../datasources/auth_api.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

/// 认证 Repository 实现
class AuthRepositoryImpl {
  final AuthApi _authApi;
  final AuthService _authService;

  AuthRepositoryImpl(this._authApi, this._authService);

  /// 登录
  Future<User> login({
    required String username,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final request = LoginRequest(
        username: username,
        password: password,
        rememberMe: rememberMe,
      );

      final response = await _authApi.login(request);

      // 通过 AuthService 登录并保存 token（AuthService 内部处理）
      final token = AuthToken(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresAt: DateTime.now().add(Duration(seconds: response.expiresIn)),
      );
      await _authService.getToken(); // 确保 token manager 可用

      // 构建 User 对象
      final user = _mapUserDataToUser(response.user);
      return user;
    } on ApiException catch (e) {
      throw _handleApiException(e);
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  /// 登出
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {
      // 即使 API 调用失败，也要清除本地数据
    } finally {
      await _authService.logout();
    }
  }

  /// 刷新令牌
  Future<void> refreshToken() async {
    try {
      await _authService.refreshToken();
    } on ApiException catch (e) {
      throw _handleApiException(e);
    } catch (e) {
      throw Exception('刷新令牌失败: $e');
    }
  }

  /// 获取当前用户（本地缓存）
  Future<User?> getCurrentUser() async {
    try {
      return await _authService.getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  /// 获取用户信息（从服务器）
  Future<User> getUserInfo() async {
    try {
      final userData = await _authApi.getUserInfo();
      return _mapUserDataToUser(userData);
    } on ApiException catch (e) {
      throw _handleApiException(e);
    } catch (e) {
      throw Exception('获取用户信息失败: $e');
    }
  }

  /// 修改密码
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _authApi.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    } on ApiException catch (e) {
      throw _handleApiException(e);
    } catch (e) {
      throw Exception('修改密码失败: $e');
    }
  }

  /// 重置密码
  Future<void> resetPassword({
    required String username,
    required String email,
  }) async {
    try {
      await _authApi.resetPassword(
        username: username,
        email: email,
      );
    } on ApiException catch (e) {
      throw _handleApiException(e);
    } catch (e) {
      throw Exception('重置密码失败: $e');
    }
  }

  /// 将 UserData 转换为 User
  User _mapUserDataToUser(UserData? userData) {
    if (userData == null) throw Exception('用户数据为空');
    return User(
      id: userData.id,
      username: userData.username,
      email: userData.email ?? '',
      avatar: userData.avatarUrl,
      phone: userData.phone,
      extra: userData.name != null ? {'name': userData.name} : null,
    );
  }

  /// 处理 API 异常
  Exception _handleApiException(ApiException e) {
    switch (e.type) {
      case ApiExceptionType.response:
        switch (e.code) {
          case 401:
            return Exception('用户名或密码错误');
          case 403:
            return Exception('没有权限');
          case 404:
            return Exception('用户不存在');
          default:
            return Exception(e.message);
        }
      case ApiExceptionType.connectTimeout:
      case ApiExceptionType.receiveTimeout:
      case ApiExceptionType.sendTimeout:
        return Exception('请求超时，请检查网络连接');
      default:
        return Exception(e.message);
    }
  }
}
