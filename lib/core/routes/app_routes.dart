import 'package:flutter/material.dart';
import '../../features/splash/splash_page.dart';
import '../../features/main/main_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'package:feature_auth/feature_auth.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

/// 应用路由配置
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String settings = '/settings';
  
  // Dashboard功能路由
  static const String ecard = '/ecard';
  static const String timetable = '/timetable';
  static const String classroom = '/classroom';
  static const String library = '/library';
  static const String exam = '/exam';
  static const String grade = '/grade';
  
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashPage(),
      home: (context) => const MainPage(),
      login: (context) => const LoginPage(),
      settings: (context) => const SettingsPage(),
    };
  }
}
