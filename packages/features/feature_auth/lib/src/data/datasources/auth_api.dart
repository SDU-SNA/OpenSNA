import 'package:core_network/core_network.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

/// 认证 API 数据源
class AuthApi {
  final ApiClient _apiClient;

  AuthApi(this._apiClient);

  /// 登录
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: request.toJson(),
    );

    return LoginResponse.fromJson(response.data);
  }

  /// 登出
  Future<void> logout() async {
    await _apiClient.post('/auth/logout');
  }

  /// 刷新令牌
  Future<LoginResponse> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    return LoginResponse.fromJson(response.data);
  }

  /// 获取用户信息
  Future<UserData> getUserInfo() async {
    final response = await _apiClient.get('/auth/user');
    return UserData.fromJson(response.data);
  }

  /// 修改密码
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _apiClient.post(
      '/auth/change-password',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );
  }

  /// 重置密码
  Future<void> resetPassword({
    required String username,
    required String email,
  }) async {
    await _apiClient.post(
      '/auth/reset-password',
      data: {
        'username': username,
        'email': email,
      },
    );
  }
}
