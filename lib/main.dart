import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'core/config/app_config.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化配置
  await AppConfig.init();
  
  // 设置系统UI样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  
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
