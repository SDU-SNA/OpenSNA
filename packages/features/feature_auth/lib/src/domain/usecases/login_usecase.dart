import 'package:core_auth/core_auth.dart';
import '../../data/repositories/auth_repository_impl.dart';

/// 登录用例
class LoginUseCase {
  final AuthRepositoryImpl _repository;

  LoginUseCase(this._repository);

  /// 执行登录
  Future<User> execute({
    required String username,
    required String password,
    bool rememberMe = false,
  }) async {
    // 验证输入
    if (username.isEmpty) {
      throw Exception('请输入用户名');
    }

    if (password.isEmpty) {
      throw Exception('请输入密码');
    }

    // 执行登录
    return await _repository.login(
      username: username,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
