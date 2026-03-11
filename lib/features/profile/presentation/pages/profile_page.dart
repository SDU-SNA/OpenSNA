import 'package:flutter/material.dart';

/// 个人中心页面
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: const Center(
        child: Text('个人中心开发中...'),
      ),
    );
  }
}
