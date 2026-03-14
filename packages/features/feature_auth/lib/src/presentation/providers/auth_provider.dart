import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_network/core_network.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

/// 认证状态
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

/// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    config: NetworkConfig(
      baseUrl: 'https://api.sdu.edu.cn',
      connectTimeout: 30000,
      receiveTimeout: 30000,
    ),
  );
});

/// Auth API Provider
final authApiProvider = Provider<AuthApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthApi(apiClient);
});

/// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient: apiClient);
});

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final authApi = ref.watch(authApiProvider);
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authApi, authService);
});

/// Login UseCase Provider
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Logout UseCase Provider
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

/// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepositoryImpl _repository;

  AuthNotifier(
    this._loginUseCase,
    this._logoutUseCase,
    this._repository,
  ) : super(const AuthState()) {
    _checkLoginStatus();
  }

  /// 检查登录状态
  Future<void> _checkLoginStatus() async {
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _repository.getCurrentUser();
        state = state.copyWith(
          user: user,
          isLoggedIn: true,
        );
      }
    } catch (e) {
      // 忽略错误，保持未登录状态
    }
  }

  /// 登录
  Future<void> login({
    required String username,
    required String password,
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _loginUseCase.execute(
        username: username,
        password: password,
        rememberMe: rememberMe,
      );

      state = state.copyWith(
        user: user,
        isLoading: false,
        isLoggedIn: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 登出
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _logoutUseCase.execute();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 刷新用户信息
  Future<void> refreshUserInfo() async {
    try {
      final user = await _repository.getUserInfo();
      state = state.copyWith(user: user);
    } catch (e) {
      // 忽略错误
    }
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth State Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  final repository = ref.watch(authRepositoryProvider);

  return AuthNotifier(loginUseCase, logoutUseCase, repository);
});
