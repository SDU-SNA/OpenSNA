import 'package:core_storage/core_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'models/auth_token.dart';

/// Token 管理器
class TokenManager {
  final SecureStorage _secureStorage;
  final StorageService _storage;

  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _expiresAtKey = 'auth_expires_at';
  static const String _tokenTypeKey = 'auth_token_type';

  TokenManager({
    SecureStorage? secureStorage,
    StorageService? storage,
  })  : _secureStorage = secureStorage ?? SecureStorage.instance,
        _storage = storage ?? StorageService.instance;

  /// 保存 Token
  Future<void> saveToken(AuthToken token) async {
    await _secureStorage.write(_accessTokenKey, token.accessToken);
    if (token.refreshToken != null) {
      await _secureStorage.write(_refreshTokenKey, token.refreshToken!);
    }
    await _storage.setString(_expiresAtKey, token.expiresAt.toIso8601String());
    await _storage.setString(_tokenTypeKey, token.tokenType);
  }

  /// 获取 Token
  Future<AuthToken?> getToken() async {
    final accessToken = await _secureStorage.read(_accessTokenKey);
    if (accessToken == null) return null;

    final refreshToken = await _secureStorage.read(_refreshTokenKey);
    final expiresAtStr = _storage.getString(_expiresAtKey);
    final tokenType = _storage.getString(_tokenTypeKey, defaultValue: 'Bearer');

    if (expiresAtStr == null) return null;

    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: DateTime.parse(expiresAtStr),
      tokenType: tokenType!,
    );
  }

  /// 获取 Access Token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(_accessTokenKey);
  }

  /// 获取 Refresh Token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(_refreshTokenKey);
  }

  /// 删除 Token
  Future<void> deleteToken() async {
    await _secureStorage.delete(_accessTokenKey);
    await _secureStorage.delete(_refreshTokenKey);
    await _storage.remove(_expiresAtKey);
    await _storage.remove(_tokenTypeKey);
  }

  /// 检查 Token 是否存在
  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null;
  }

  /// 检查 Token 是否有效
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;
    return !token.isExpired;
  }

  /// 检查 Token 是否即将过期
  Future<bool> isTokenExpiringSoon() async {
    final token = await getToken();
    if (token == null) return false;
    return token.isExpiringSoon;
  }

  /// 解码 JWT Token
  Map<String, dynamic>? decodeToken(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  /// 获取 Token 过期时间
  DateTime? getTokenExpirationDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }

  /// 检查 JWT Token 是否过期
  bool isJwtExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }
}
