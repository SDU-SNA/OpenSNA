import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feature_auth/feature_auth.dart';

/// Dashboard 首页
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('山大网管会'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('通知功能开发中')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: 刷新数据
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 用户信息卡片
            _buildUserCard(context, user),
            
            const SizedBox(height: 16),
            
            // 快捷功能
            _buildQuickActions(context),
            
            const SizedBox(height: 16),
            
            // 公告栏
            _buildAnnouncementSection(context),
            
            const SizedBox(height: 16),
            
            // 常用服务
            _buildServicesSection(context),
          ],
        ),
      ),
    );
  }

  /// 用户信息卡片
  Widget _buildUserCard(BuildContext context, User? user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 头像
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: user?.avatarUrl != null
                  ? ClipOval(
                      child: Image.network(
                        user!.avatarUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 30,
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '欢迎使用山大网管会',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            
            // 箭头
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// 快捷功能
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.wifi,
        label: '网络账号',
        color: Colors.blue,
        onTap: () => _showComingSoon(context, '网络账号'),
      ),
      _QuickAction(
        icon: Icons.devices,
        label: '在线设备',
        color: Colors.green,
        onTap: () => _showComingSoon(context, '在线设备'),
      ),
      _QuickAction(
        icon: Icons.speed,
        label: '网络测速',
        color: Colors.orange,
        onTap: () => _showComingSoon(context, '网络测速'),
      ),
      _QuickAction(
        icon: Icons.build,
        label: '故障报修',
        color: Colors.red,
        onTap: () => _showComingSoon(context, '故障报修'),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '快捷功能',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions.map((action) {
                return _buildQuickActionItem(context, action);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(BuildContext context, _QuickAction action) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                action.icon,
                color: action.color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 公告栏
  Widget _buildAnnouncementSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '公告通知',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => _showComingSoon(context, '更多公告'),
                  child: const Text('更多'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAnnouncementItem(
              context,
              '欢迎使用山大网管会APP',
              '2026-03-11',
            ),
            const Divider(),
            _buildAnnouncementItem(
              context,
              '网络服务升级通知',
              '2026-03-10',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementItem(
    BuildContext context,
    String title,
    String date,
  ) {
    return InkWell(
      onTap: () => _showComingSoon(context, '公告详情'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.campaign,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// 常用服务
  Widget _buildServicesSection(BuildContext context) {
    final services = [
      _ServiceItem(
        icon: Icons.calendar_today,
        title: '课程表',
        subtitle: '查看我的课程',
        onTap: () => _showComingSoon(context, '课程表'),
      ),
      _ServiceItem(
        icon: Icons.grade,
        title: '成绩查询',
        subtitle: '查看考试成绩',
        onTap: () => _showComingSoon(context, '成绩查询'),
      ),
      _ServiceItem(
        icon: Icons.room,
        title: '教室查询',
        subtitle: '查找空闲教室',
        onTap: () => _showComingSoon(context, '教室查询'),
      ),
      _ServiceItem(
        icon: Icons.library_books,
        title: '图书馆',
        subtitle: '图书借阅服务',
        onTap: () => _showComingSoon(context, '图书馆'),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '常用服务',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...services.map((service) {
              return Column(
                children: [
                  _buildServiceItem(context, service),
                  if (service != services.last) const Divider(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, _ServiceItem service) {
    return InkWell(
      onTap: service.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                service.icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature功能开发中')),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _ServiceItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _ServiceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
