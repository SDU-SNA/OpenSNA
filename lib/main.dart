import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'core/config/app_config.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/services/toolkit_initializer.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化Toolkit包（日志、崩溃收集等）
  await _initializeToolkits();
  
  // 初始化应用配置
  await AppConfig.init();
  
  // 设置系统UI样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  
  // 使用Zone捕获所有未处理的异常
  runZonedGuarded(
    () {
      runApp(
        ProviderScope(
          child: provider.MultiProvider(
            providers: [
              provider.ChangeNotifierProvider(create: (_) => SettingsProvider()),
              provider.ChangeNotifierProvider(create: (_) => AuthProvider()),
            ],
            child: const SDUSNAApp(),
          ),
        ),
      );
    },
    (error, stackTrace) {
      // 捕获并上报所有未处理的异常
      ToolkitInitializer.logError(
        '未处理的异常',
        tag: 'App',
        error: error,
        stackTrace: stackTrace,
      );
      ToolkitInitializer.reportCrash(error, stackTrace);
    },
  );
}

/// 初始化Toolkit包
Future<void> _initializeToolkits() async {
  try {
    await ToolkitInitializer.initialize(
      enableFileLog: true,
      enableRemoteLog: false, // 生产环境可以设置为true
      remoteLogUrl: 'https://log.sdu.edu.cn/api/logs',
      crashReportUrl: 'https://crash.sdu.edu.cn/api/report',
      appVersion: '0.1.0',
    );
    
    ToolkitInitializer.log('应用启动', tag: 'App');
  } catch (e, stackTrace) {
    debugPrint('Toolkit初始化失败: $e');
    debugPrint('StackTrace: $stackTrace');
    // 即使Toolkit初始化失败，应用也应该继续运行
  }
}

class SDUSNAApp extends StatelessWidget {
  const SDUSNAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: '山大网管会',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          locale: settings.locale,
          supportedLocales: const [
            Locale('zh', 'CN'),
            Locale('en', 'US'),
          ],
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.home,
        );
      },
    );
  }
}
