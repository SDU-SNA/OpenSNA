import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../widgets/feature_card.dart';

/// Dashboard页面
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('山大网管会'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: 打开通知页面
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: 刷新数据
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 用户信息卡片
            _buildUserCard(context, authProvider),
            const SizedBox(height: 16),
            
            // 功能卡片网格
            _buildFeatureGrid(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUserCard(BuildContext context, AuthProvider authProvider) {
    if (!authProvider.isLoggedIn) {
      return Card(
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: const Text('未登录'),
          subtitle: const Text('点击登录'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              child: Icon(Icons.person, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authProvider.username ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '学号: ${authProvider.studentId ?? ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        FeatureCard(
          icon: Icons.credit_card,
          title: '校园卡',
          onTap: () => Navigator.pushNamed(context, '/ecard'),
        ),
        FeatureCard(
          icon: Icons.calendar_today,
          title: '课表',
          onTap: () => Navigator.pushNamed(context, '/timetable'),
        ),
        FeatureCard(
          icon: Icons.meeting_room,
          title: '空教室',
          onTap: () => Navigator.pushNamed(context, '/classroom'),
        ),
        FeatureCard(
          icon: Icons.library_books,
          title: '图书馆',
          onTap: () => Navigator.pushNamed(context, '/library'),
        ),
        FeatureCard(
          icon: Icons.assignment,
          title: '考试',
          onTap: () => Navigator.pushNamed(context, '/exam'),
        ),
        FeatureCard(
          icon: Icons.grade,
          title: '成绩',
          onTap: () => Navigator.pushNamed(context, '/grade'),
        ),
      ],
    );
  }
}
