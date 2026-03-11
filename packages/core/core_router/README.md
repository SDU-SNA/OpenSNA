# core_router

路由层核心包，提供统一的路由管理和导航，基于 go_router 封装。

## 功能特性

- ✅ 声明式路由配置
- ✅ 命名路由支持
- ✅ 路由参数传递
- ✅ 路由守卫（重定向）
- ✅ 错误页面处理
- ✅ 便捷的扩展方法

## 安装

```yaml
dependencies:
  core_router:
    path: ../core/core_router
```

## 使用示例

### 1. 配置路由

```dart
import 'package:core_router/core_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SDU-SNA',
      routerConfig: AppRouter.createRouter(),
    );
  }
}
```

### 2. 使用路由路径

```dart
import 'package:core_router/core_router.dart';

// 所有路由路径都定义在 AppRoutes 中
AppRoutes.root       // '/'
AppRoutes.login      // '/login'
AppRoutes.home       // '/home'
AppRoutes.profile    // '/profile'
AppRoutes.settings   // '/settings'
```

### 3. 导航到页面

```dart
import 'package:core_router/core_router.dart';

// 使用扩展方法导航
context.navigateTo(AppRoutes.home);

// 使用命名路由
context.navigateToNamed('home');

// 带参数导航
context.navigateTo(
  '/user/123',
  extra: {'name': 'John'},
);
```

### 4. 推送新页面

```dart
// 推送新页面（可以返回）
final result = await context.pushTo<String>(AppRoutes.profile);

// 推送命名路由
final result = await context.pushToNamed<String>('profile');
```

### 5. 替换当前页面

```dart
// 替换当前页面（不可返回）
context.replaceTo(AppRoutes.home);

// 替换命名路由
context.replaceToNamed('home');
```

### 6. 返回上一页

```dart
// 返回上一页
context.goBack();

// 返回并传递结果
context.goBack('result data');

// 检查是否可以返回
if (context.canGoBack()) {
  context.goBack();
}
```

### 7. 获取路由信息

```dart
// 获取当前路径
final path = context.currentPath;

// 获取路径参数
final params = context.pathParameters;
final userId = params['id'];

// 获取查询参数
final query = context.queryParameters;
final page = query['page'];

// 获取额外数据
final extra = context.extra;
```

### 8. 自定义路由配置

```dart
final router = AppRouter.createRouter(
  initialLocation: AppRoutes.home,
  redirect: (context, state) {
    // 路由守卫逻辑
    final isLoggedIn = checkLoginStatus();
    final isLoginRoute = state.matchedLocation == AppRoutes.login;
    
    if (!isLoggedIn && !isLoginRoute) {
      return AppRoutes.login;
    }
    
    if (isLoggedIn && isLoginRoute) {
      return AppRoutes.home;
    }
    
    return null;
  },
  observers: [
    MyNavigatorObserver(),
  ],
);
```

### 9. 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:core_router/core_router.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 导航到个人中心
                context.navigateTo(AppRoutes.profile);
              },
              child: Text('个人中心'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // 推送设置页面并等待结果
                final result = await context.pushTo<bool>(
                  AppRoutes.settings,
                );
                if (result == true) {
                  print('设置已保存');
                }
              },
              child: Text('设置'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 登出并替换到登录页
                context.replaceTo(AppRoutes.login);
              },
              child: Text('登出'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 路由配置

### 预定义路由

- `/` - 根路径
- `/login` - 登录页
- `/register` - 注册页
- `/home` - 首页
- `/profile` - 个人中心
- `/settings` - 设置页
- `/dashboard` - 仪表盘
- `/community` - 社区
- `/timetable` - 课程表

### 添加新路由

在实际使用时，需要在 `AppRouter._routes` 中添加实际的页面构建器：

```dart
GoRoute(
  path: AppRoutes.home,
  name: 'home',
  builder: (context, state) => HomePage(),
),
```

## 扩展方法

### BuildContext 扩展

- `navigateTo(path)` - 导航到指定路径
- `navigateToNamed(name)` - 导航到命名路由
- `replaceTo(path)` - 替换当前路由
- `replaceToNamed(name)` - 替换命名路由
- `pushTo<T>(path)` - 推送新路由
- `pushToNamed<T>(name)` - 推送命名路由
- `goBack([result])` - 返回上一页
- `canGoBack()` - 是否可以返回
- `currentPath` - 获取当前路径
- `pathParameters` - 获取路径参数
- `queryParameters` - 获取查询参数
- `extra` - 获取额外数据

## 注意事项

1. **路由配置**: 需要在实际项目中替换 Placeholder 为真实页面
2. **路由守卫**: 可以通过 redirect 参数实现认证检查等逻辑
3. **参数传递**: 支持路径参数、查询参数和 extra 数据
4. **错误处理**: 自动显示错误页面

## 依赖

- go_router: ^14.0.0

## 许可证

MIT
