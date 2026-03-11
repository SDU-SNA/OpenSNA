import '../../data/repositories/auth_repository_impl.dart';

/// 登出用例
class LogoutUseCase {
  final AuthRepositoryImpl _repository;

  LogoutUseCase(this._repository);

  /// 执行登出
  Future<void> execute() async {
    await _repository.logout();
  }
}
