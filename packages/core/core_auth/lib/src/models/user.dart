/// 用户模型
class User {
  final String id;
  final String username;
  final String email;
  final String? avatar;
  final String? phone;
  final DateTime? createdAt;
  final Map<String, dynamic>? extra;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    this.phone,
    this.createdAt,
    this.extra,
  });

  /// 从 JSON 创建
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      extra: json['extra'] as Map<String, dynamic>?,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'phone': phone,
      'created_at': createdAt?.toIso8601String(),
      'extra': extra,
    };
  }

  /// 复制并修改
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? avatar,
    String? phone,
    DateTime? createdAt,
    Map<String, dynamic>? extra,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      extra: extra ?? this.extra,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
