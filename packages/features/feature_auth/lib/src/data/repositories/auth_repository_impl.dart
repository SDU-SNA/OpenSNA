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
      // 调用 API 登录
      final request = LoginRequest(
        username: username,
        password: password,
        rememberMe: rememberMe,
      );
      
      final response = await _authApi.login(request);
      
      // 保存 Token
      await _authService.saveToken(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresIn: response.expiresIn,
      );
      
      // 转换并保存用户信息
      final user = _mapUserDataToUser(response.user);
      await _authService.saveUser(user);
      
      // 如果记住密码，保存凭据
      if (rememberMe) {
        // TODO: 实现记住密码功能
      }
      
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
      // 调用 API 登出
      await _authApi.logout();
    } catch (e) {
      // 即使 API 调用失败，也要清除本地数据
    } finally {
      // 清除本地认证数据
      await _authService.logout();
    }
  }

  /// 刷新令牌
  Future<void> refreshToken() async {
    try {
      final currentToken = await _authService.getToken();
      if (currentToken == null || currentToken.refreshToken.isEmpty) {
        throw Exception('没有可用的刷新令牌');
      }
      
      final response = await _authApi.refreshToken(currentToken.refreshToken);
      
      await _authService.saveToken(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresIn: response.expiresIn,
      );
    } on ApiException catch (e) {
      throw _handleApiException(e);
    } catch (e) {
      throw Exception('刷新令牌失败: $e');
    }
  }

  /// 获取当前用户
  Future<User?> getCurrentUser() async {
    return await _authService.getUser();
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  /// 获取用户信息（从服务器）
  Future<User> getUserInfo() async {
    try {
      final userData = await _authApi.getUserInfo();
      final user = _mapUserDataToUser(userData);
      await _authService.saveUser(user);
      return user;
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
    if (userData == null) {
      throw Exception('用户数据为空');
    }
    
    return User(
      id: userData.id,
      username: userData.username,
      name: userData.name,
      email: userData.email,
      phone: userData.phone,
      avatarUrl: userData.avatarUrl,
    );
  }

  /// 处理 API 异常
  Exception _handleApiException(ApiException e) {
    switch (e.type) {
      case ApiExceptionType.unauthorized:
        return Exception('用户名或密码错误');
      case ApiExceptionType.forbidden:
        return Exception('没有权限');
      case ApiExceptionType.notFound:
        return Exception('用户不存在');
      case ApiExceptionType.timeout:
        return Exception('请求超时，请检查网络连接');
      case ApiExceptionType.noInternet:
        return Exception('无网络连接');
      case ApiExceptionType.serverError:
        return Exception('服务器错误，请稍后重试');
      default:
        return Exception(e.message ?? '未知错误');
    }
  }
}
