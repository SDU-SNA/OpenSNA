/// API异常类
class ApiException implements Exception {
  final String message;
  final int? code;
  
  ApiException(this.message, [this.code]);
  
  @override
  String toString() => 'ApiException: $message (code: $code)';
}

/// 网络异常
class NetworkException extends ApiException {
  NetworkException([String message = '网络连接失败']) : super(message);
}

/// 认证异常
class AuthException extends ApiException {
  AuthException([String message = '认证失败']) : super(message, 401);
}

/// 服务器异常
class ServerException extends ApiException {
  ServerException([String message = '服务器错误']) : super(message, 500);
}
