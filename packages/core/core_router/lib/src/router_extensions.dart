import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// BuildContext 路由扩展
extension RouterExtensions on BuildContext {
  /// 导航到指定路径
  void navigateTo(String path, {Object? extra}) {
    go(path, extra: extra);
  }

  /// 导航到指定路径（命名路由）
  void navigateToNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
    goNamed(name, pathParameters: pathParameters ?? {}, queryParameters: queryParameters ?? {}, extra: extra);
  }

  /// 替换当前路由
  void replaceTo(String path, {Object? extra}) {
    replace(path, extra: extra);
  }

  /// 替换当前路由（命名路由）
  void replaceToNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
    replaceNamed(name, pathParameters: pathParameters ?? {}, queryParameters: queryParameters ?? {}, extra: extra);
  }

  /// 推送新路由
  Future<T?> pushTo<T>(String path, {Object? extra}) {
    return push<T>(path, extra: extra);
  }

  /// 推送新路由（命名路由）
  Future<T?> pushToNamed<T>(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
    return pushNamed<T>(name, pathParameters: pathParameters ?? {}, queryParameters: queryParameters ?? {}, extra: extra);
  }

  /// 返回上一页
  void goBack<T>([T? result]) {
    if (canPop()) {
      pop(result);
    }
  }

  /// 是否可以返回
  bool canGoBack() {
    return canPop();
  }

  /// 获取当前路由路径
  String get currentPath {
    return GoRouterState.of(this).matchedLocation;
  }

  /// 获取路由参数
  Map<String, String> get pathParameters {
    return GoRouterState.of(this).pathParameters;
  }

  /// 获取查询参数
  Map<String, dynamic> get queryParameters {
    return GoRouterState.of(this).uri.queryParameters;
  }

  /// 获取额外数据
  Object? get extra {
    return GoRouterState.of(this).extra;
  }
}
