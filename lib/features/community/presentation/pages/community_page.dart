import 'package:flutter/material.dart';

/// 社区页面
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('社区'),
      ),
      body: const Center(
        child: Text('社区功能开发中...'),
      ),
    );
  }
}
