import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

/// 登录响应模型
@JsonSerializable()
class LoginResponse {
  /// 访问令牌
  @JsonKey(name: 'access_token')
  final String accessToken;
  
  /// 刷新令牌
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  
  /// 令牌类型
  @JsonKey(name: 'token_type')
  final String tokenType;
  
  /// 过期时间（秒）
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  
  /// 用户信息
  @JsonKey(name: 'user')
  final UserData? user;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    required this.expiresIn,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

/// 用户数据模型
@JsonSerializable()
class UserData {
  /// 用户ID
  final String id;
  
  /// 用户名
  final String username;
  
  /// 姓名
  final String? name;
  
  /// 邮箱
  final String? email;
  
  /// 手机号
  final String? phone;
  
  /// 头像URL
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  const UserData({
    required this.id,
    required this.username,
    this.name,
    this.email,
    this.phone,
    this.avatarUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
