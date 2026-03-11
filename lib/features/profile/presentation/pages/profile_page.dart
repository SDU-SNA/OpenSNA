import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feature_auth/feature_auth.dart';

/// 个人中心页面
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // 用户信息头部
          _buildUserHeader(context, ref, user),
          
          const SizedBox(height: 8),
          
          // 账号管理
          _buildSection(
            context,
            title: '账号管理',
            items: [
              _MenuItem(
                icon: Icons.person_outline,
                title: '个人资料',
                onTap: () => _showComingSoon(context, '个人资料'),
              ),
              _MenuItem(
                icon: Icons.lock_outline,
                title: '修改密码',
                onTap: () => _showComingSoon(context, '修改密码'),
              ),
              _MenuItem(
                icon: Icons.security_outlined,
                title: '账号安全',
                onTap: () => _showComingSoon(context, '账号安全'),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 应用设置
          _buildSection(
            context,
            title: '应用设置',
            items: [
              _MenuItem(
                icon: Icons.notifications_outlined,
                title: '消息通知',
                onTap: () => _showComingSoon(context, '消息通知'),
              ),
              _MenuItem(
                icon: Icons.language_outlined,
                title: '语言设置',
                onTap: () => _showComingSoon(context, '语言设置'),
              ),
              _MenuItem(
                icon: Icons.palette_outlined,
                title: '主题设置',
                onTap: () => _showComingSoon(context, '主题设置'),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 其他
          _buildSection(
            context,
            title: '其他',
            items: [
              _MenuItem(
                icon: Icons.help_outline,
                title: '帮助与反馈',
                onTap: () => _showComingSoon(context, '帮助与反馈'),
              ),
              _MenuItem(
                icon: Icons.info_outline,
                title: '关于我们',
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 退出登录按钮
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: () => _handleLogout(context, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('退出登录'),
              ),
            ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// 用户信息头部
  Widget _buildUserHeader(BuildContext context, WidgetRef ref, User? user) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: user?.avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      user!.avatarUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
          ),
          
          const SizedBox(width: 16),
          
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? user?.username ?? '未登录',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '点击登录',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                if (user?.phone != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user!.phone!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ],
            ),
          ),
          
          // 箭头或登录按钮
          if (user != null)
            const Icon(Icons.chevron_right, color: Colors.grey)
          else
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('登录'),
            ),
        ],
      ),
    );
  }

  /// 构建分组
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildMenuItem(context, item),
                  if (index < items.length - 1)
                    const Divider(height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return ListTile(
      leading: Icon(item.icon, color: Theme.of(context).primaryColor),
      title: Text(item.title),
      trailing: item.trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: item.onTap,
    );
  }

  /// 退出登录
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(authProvider.notifier).logout();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('退出失败: $e')),
          );
        }
      }
    }
  }

  /// 显示关于对话框
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: '山大网管会',
      applicationVersion: '0.2.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.school,
          color: Colors.white,
          size: 30,
        ),
      ),
      children: [
        const SizedBox(height: 16),
        const Text('山东大学网管会一站式服务应用'),
        const SizedBox(height: 8),
        const Text('为师生提供便捷的网络服务'),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature功能开发中')),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });
}
