import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_network_service/feature_network_service.dart';
import 'package:feature_campus_info/feature_campus_info.dart';
import 'package:feature_academic/feature_academic.dart';
import 'package:feature_convenience/feature_convenience.dart';

/// Dashboard 首页
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

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
            onPressed: () => _navigate(context, const CampusInfoPage()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _UserCard(user: user),
            const SizedBox(height: 16),
            _QuickActionsCard(onNavigate: _navigate),
            const SizedBox(height: 16),
            _AnnouncementSection(onNavigate: _navigate),
            const SizedBox(height: 16),
            _ServicesSection(onNavigate: _navigate),
          ],
        ),
      ),
    );
  }
}

/// 用户信息卡片
class _UserCard extends StatelessWidget {
  final User? user;

  const _UserCard({this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(Icons.person,
                  size: 28, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.extra?['name'] as String? ?? user?.username ?? '未登录',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    user?.email ?? '欢迎使用山大网管会',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
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
}

/// 快捷功能卡片
class _QuickActionsCard extends StatelessWidget {
  final void Function(BuildContext, Widget) onNavigate;

  const _QuickActionsCard({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        icon: Icons.wifi,
        label: '网络账号',
        color: Colors.blue,
        page: const NetworkAccountPage()
      ),
      (
        icon: Icons.devices,
        label: '在线设备',
        color: Colors.green,
        page: const DeviceManagePage()
      ),
      (
        icon: Icons.speed,
        label: '网络测速',
        color: Colors.orange,
        page: const SpeedTestPage()
      ),
      (
        icon: Icons.build,
        label: '故障报修',
        color: Colors.red,
        page: const RepairPage()
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('快捷功能',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions.map((a) {
                return InkWell(
                  onTap: () => onNavigate(context, a.page),
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 68,
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: a.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(a.icon, color: a.color, size: 26),
                        ),
                        const SizedBox(height: 6),
                        Text(a.label,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// 公告栏
class _AnnouncementSection extends StatelessWidget {
  final void Function(BuildContext, Widget) onNavigate;

  const _AnnouncementSection({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('公告通知',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => onNavigate(context, const CampusInfoPage()),
                  child: const Text('更多'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _AnnouncementItem(
              title: '欢迎使用山大网管会APP',
              date: '2026-03-11',
              onTap: () => onNavigate(context, const CampusInfoPage()),
            ),
            const Divider(height: 1),
            _AnnouncementItem(
              title: '网络服务升级通知',
              date: '2026-03-10',
              onTap: () => onNavigate(context, const CampusInfoPage()),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementItem extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onTap;

  const _AnnouncementItem(
      {required this.title, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(Icons.campaign,
                size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  Text(date,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

/// 常用服务
class _ServicesSection extends StatelessWidget {
  final void Function(BuildContext, Widget) onNavigate;

  const _ServicesSection({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final services = [
      (
        icon: Icons.calendar_today,
        title: '课程表',
        subtitle: '查看我的课程',
        page: const AcademicTimetablePage()
      ),
      (
        icon: Icons.grade,
        title: '成绩查询',
        subtitle: '查看考试成绩',
        page: const GradesPage()
      ),
      (
        icon: Icons.meeting_room,
        title: '教室查询',
        subtitle: '查找空闲教室',
        page: const ClassroomPage()
      ),
      (
        icon: Icons.local_library,
        title: '图书馆',
        subtitle: '座位与开放状态',
        page: const LibraryPage()
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('常用服务',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...services.asMap().entries.map((entry) {
              final s = entry.value;
              return Column(
                children: [
                  InkWell(
                    onTap: () => onNavigate(context, s.page),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(s.icon,
                                color: Theme.of(context).colorScheme.primary,
                                size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500)),
                                Text(s.subtitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: Colors.grey, size: 18),
                        ],
                      ),
                    ),
                  ),
                  if (entry.key < services.length - 1) const Divider(height: 1),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
