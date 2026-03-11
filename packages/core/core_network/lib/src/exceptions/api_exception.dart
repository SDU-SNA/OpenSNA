import 'package:dio/dio.dart';

/// API异常类型
enum ApiExceptionType {
  /// 网络连接错误
  connectTimeout,

  /// 发送超时
  sendTimeout,

  /// 接收超时
  receiveTimeout,

  /// 响应错误
  response,

  /// 取消请求
  cancel,

  /// 未知错误
  unknown,
}

/// API异常
class ApiException implements Exception {
  /// 异常类型
  final ApiExceptionType type;

  /// 错误码
  final int? code;

  /// 错误消息
  final String message;

  /// 原始错误
  final dynamic originalError;

  const ApiException({
    required this.type,
    this.code,
    required this.message,
    this.originalError,
  });

  /// 从DioException创建
  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          type: ApiExceptionType.connectTimeout,
          message: '连接超时，请检查网络',
          originalError: error,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          type: ApiExceptionType.sendTimeout,
          message: '请求超时，请稍后重试',
          originalError: error,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          type: ApiExceptionType.receiveTimeout,
          message: '响应超时，请稍后重试',
          originalError: error,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return ApiException(
          type: ApiExceptionType.response,
          code: statusCode,
          message: _getResponseErrorMessage(statusCode),
          originalError: error,
        );
      case DioExceptionType.cancel:
        return ApiException(
          type: ApiExceptionType.cancel,
          message: '请求已取消',
          originalError: error,
        );
      default:
        return ApiException(
          type: ApiExceptionType.unknown,
          message: '网络异常，请稍后重试',
          originalError: error,
        );
    }
  }

  /// 获取响应错误消息
  static String _getResponseErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请重新登录';
      case 403:
        return '拒绝访问';
      case 404:
        return '请求的资源不存在';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务不可用';
      case 504:
        return '网关超时';
      default:
        return '网络错误($statusCode)';
    }
  }

  @override
  String toString() {
    return 'ApiException(type: $type, code: $code, message: $message)';
  }
}
