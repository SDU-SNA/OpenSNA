import 'user.dart';
import 'auth_token.dart';

/// 认证状态
enum AuthStatus {
  /// 未认证
  unauthenticated,

  /// 已认证
  authenticated,

  /// 认证中
  authenticating,

  /// 认证失败
  failed,
}

/// 认证状态模型
class AuthState {
  final AuthStatus status;
  final User? user;
  final AuthToken? token;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.token,
    this.errorMessage,
  });

  /// 初始状态
  const AuthState.initial()
      : status = AuthStatus.unauthenticated,
        user = null,
        token = null,
        errorMessage = null;

  /// 认证中状态
  const AuthState.authenticating()
      : status = AuthStatus.authenticating,
        user = null,
        token = null,
        errorMessage = null;

  /// 已认证状态
  const AuthState.authenticated({
    required User user,
    required AuthToken token,
  })  : status = AuthStatus.authenticated,
        user = user,
        token = token,
        errorMessage = null;

  /// 认证失败状态
  const AuthState.failed(String message)
      : status = AuthStatus.failed,
        user = null,
        token = null,
        errorMessage = message;

  /// 是否已认证
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// 是否认证中
  bool get isAuthenticating => status == AuthStatus.authenticating;

  /// 是否未认证
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  /// 是否认证失败
  bool get isFailed => status == AuthStatus.failed;

  /// 复制并修改
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    AuthToken? token,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'AuthState(status: $status, user: $user, hasToken: ${token != null})';
  }
}
