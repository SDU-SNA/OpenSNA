import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 认证状态管理
class AuthProvider extends ChangeNotifier {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'username';
  static const String _keyStudentId = 'student_id';
  
  bool _isLoggedIn = false;
  String? _username;
  String? _studentId;
  
  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get studentId => _studentId;
  
  AuthProvider() {
    _loadAuthState();
  }
  
  /// 加载认证状态
  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    _username = prefs.getString(_keyUsername);
    _studentId = prefs.getString(_keyStudentId);
    notifyListeners();
  }
  
  /// 登录
  Future<void> login(String username, String studentId) async {
    _isLoggedIn = true;
    _username = username;
    _studentId = studentId;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyStudentId, studentId);
  }
  
  /// 登出
  Future<void> logout() async {
    _isLoggedIn = false;
    _username = null;
    _studentId = null;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
