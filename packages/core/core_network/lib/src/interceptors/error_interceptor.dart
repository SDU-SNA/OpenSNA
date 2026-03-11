import 'package:dio/dio.dart';
import '../exceptions/api_exception.dart';

/// 错误拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 将DioException转换为ApiException
    final apiException = ApiException.fromDioException(err);

    // 传递转换后的异常
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiException,
        type: err.type,
        response: err.response,
      ),
    );
  }
}
