import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 设置状态管理
class SettingsProvider extends ChangeNotifier {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLocale = 'locale';
  
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('zh', 'CN');
  
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  
  SettingsProvider() {
    _loadSettings();
  }
  
  /// 加载设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 加载主题模式
    final themeModeIndex = prefs.getInt(_keyThemeMode) ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex];
    
    // 加载语言
    final localeCode = prefs.getString(_keyLocale) ?? 'zh_CN';
    final parts = localeCode.split('_');
    _locale = Locale(parts[0], parts.length > 1 ? parts[1] : '');
    
    notifyListeners();
  }
  
  /// 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }
  
  /// 设置语言
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, '${locale.languageCode}_${locale.countryCode}');
  }
}
