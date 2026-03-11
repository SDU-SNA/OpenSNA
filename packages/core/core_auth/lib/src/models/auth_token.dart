/// 认证令牌模型
class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  const AuthToken({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  /// 从 JSON 创建
  factory AuthToken.fromJson(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'] as int?;
    final expiresAt = expiresIn != null
        ? DateTime.now().add(Duration(seconds: expiresIn))
        : json['expires_at'] != null
            ? DateTime.parse(json['expires_at'] as String)
            : DateTime.now().add(const Duration(hours: 24));

    return AuthToken(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: expiresAt,
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
      'token_type': tokenType,
    };
  }

  /// 检查是否过期
  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// 检查是否即将过期（5分钟内）
  bool get isExpiringSoon {
    final fiveMinutesLater = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesLater.isAfter(expiresAt);
  }

  /// 获取剩余有效时间
  Duration get remainingTime {
    return expiresAt.difference(DateTime.now());
  }

  @override
  String toString() {
    return 'AuthToken(tokenType: $tokenType, expiresAt: $expiresAt, isExpired: $isExpired)';
  }
}
