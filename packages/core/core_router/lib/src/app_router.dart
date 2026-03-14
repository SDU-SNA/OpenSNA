import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 路由路径常量
class AppRoutes {
  AppRoutes._();

  // 根路径
  static const String root = '/';

  // 认证相关
  static const String login = '/login';
  static const String register = '/register';

  // 主页面
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // 功能页面
  static const String dashboard = '/dashboard';
  static const String community = '/community';
  static const String timetable = '/timetable';
}

/// 应用路由配置
class AppRouter {
  AppRouter._();

  /// 创建路由配置
  static GoRouter createRouter({
    String? initialLocation,
    GlobalKey<NavigatorState>? navigatorKey,
    List<NavigatorObserver>? observers,
    GoRouterRedirect? redirect,
  }) {
    return GoRouter(
      initialLocation: initialLocation ?? AppRoutes.root,
      navigatorKey: navigatorKey,
      observers: observers,
      redirect: redirect,
      routes: _routes,
      errorBuilder: _errorBuilder,
    );
  }

  /// 路由列表
  static final List<RouteBase> _routes = [
    GoRoute(
      path: AppRoutes.root,
      name: 'root',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.community,
      name: 'community',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.timetable,
      name: 'timetable',
      builder: (context, state) => const Placeholder(),
    ),
  ];

  /// 错误页面构建器
  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '页面未找到',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
