import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// 登录请求模型
@JsonSerializable()
class LoginRequest {
  /// 用户名（学号/工号）
  final String username;

  /// 密码
  final String password;

  /// 是否记住密码
  @JsonKey(name: 'remember_me')
  final bool rememberMe;

  const LoginRequest({
    required this.username,
    required this.password,
    this.rememberMe = false,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
