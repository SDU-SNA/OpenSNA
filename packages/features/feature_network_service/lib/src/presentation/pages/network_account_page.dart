import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/network_providers.dart';
import '../../data/models/network_account.dart';

/// 网络账号管理页面
class NetworkAccountPage extends ConsumerWidget {
  const NetworkAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(networkAccountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('网络账号'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(networkAccountProvider);
            },
            tooltip: '刷新',
          ),
        ],
      ),
      body: accountState.when(
        data: (account) => _buildContent(context, ref, account),
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(
          error: error.toString(),
          onRetry: () {
            ref.invalidate(networkAccountProvider);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, NetworkAccount account) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(networkAccountProvider);
        await ref.read(networkAccountProvider.future);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 账号信息卡片
            _buildAccountInfoCard(account),
            const SizedBox(height: 16),
            // 余额卡片
            _buildBalanceCard(context, account),
            const SizedBox(height: 16),
            // 流量统计卡片
            _buildTrafficCard(account),
            const SizedBox(height: 16),
            // 套餐信息卡片
            _buildPackageCard(account),
            const SizedBox(height: 16),
            // 快捷操作
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  /// 账号信息卡片
  Widget _buildAccountInfoCard(NetworkAccount account) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 48,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.username,
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatusChip(account),
                          if (account.isExpiringSoon) ...[
                            const SizedBox(width: 8),
                            _buildExpiringChip(),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('账号ID', account.id),
            _buildInfoRow(
              '到期时间',
              '${account.expireTime.year}-${account.expireTime.month.toString().padLeft(2, '0')}-${account.expireTime.day.toString().padLeft(2, '0')}',
            ),
          ],
        ),
      ),
    );
  }

  /// 状态标签
  Widget _buildStatusChip(NetworkAccount account) {
    Color color;
    String text;

    if (account.isActive) {
      color = AppColors.success;
      text = '正常';
    } else if (account.isExpired) {
      color = AppColors.error;
      text = '已过期';
    } else {
      color = AppColors.warning;
      text = '停用';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 即将到期标签
  Widget _buildExpiringChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber,
            size: 14,
            color: AppColors.warning,
          ),
          const SizedBox(width: 4),
          Text(
            '即将到期',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 余额卡片
  Widget _buildBalanceCard(BuildContext context, NetworkAccount account) {
    return Card(
      child: InkWell(
        onTap: () {
          _showRechargeDialog(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '账户余额',
                    style: AppTextStyles.titleMedium,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¥',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    account.balance.toStringAsFixed(2),
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _showRechargeDialog(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('充值'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 流量统计卡片
  Widget _buildTrafficCard(NetworkAccount account) {
    final usagePercent = account.trafficUsagePercent;
    final remaining = account.remainingTraffic;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '流量统计',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            // 流量进度条
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '已用 ${account.usedTraffic.toStringAsFixed(2)} GB',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      '剩余 ${remaining.toStringAsFixed(2)} GB',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: usagePercent / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      usagePercent > 90
                          ? AppColors.error
                          : usagePercent > 70
                              ? AppColors.warning
                              : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${usagePercent.toStringAsFixed(1)}% 已使用',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 流量详情
            Row(
              children: [
                Expanded(
                  child: _buildTrafficItem(
                    '总流量',
                    '${account.totalTraffic.toStringAsFixed(2)} GB',
                    Icons.cloud,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTrafficItem(
                    '已用流量',
                    '${account.usedTraffic.toStringAsFixed(2)} GB',
                    Icons.cloud_download,
                    AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 流量项
  Widget _buildTrafficItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 套餐信息卡片
  Widget _buildPackageCard(NetworkAccount account) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '套餐信息',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('套餐名称', account.packageName),
            _buildInfoRow('套餐价格', '¥${account.packagePrice.toStringAsFixed(2)}/月'),
            _buildInfoRow('套餐流量', '${account.totalTraffic.toStringAsFixed(2)} GB/月'),
          ],
        ),
      ),
    );
  }

  /// 快捷操作
  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '快捷操作',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildActionItem(
              icon: Icons.history,
              title: '流量使用历史',
              onTap: () {
                // TODO: 跳转到流量历史页面
              },
            ),
            _buildActionItem(
              icon: Icons.receipt_long,
              title: '消费记录',
              onTap: () {
                // TODO: 跳转到消费记录页面
              },
            ),
            _buildActionItem(
              icon: Icons.settings,
              title: '套餐管理',
              onTap: () {
                // TODO: 跳转到套餐管理页面
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 操作项
  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  /// 信息行
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// 显示充值对话框
  void _showRechargeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('充值'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('请选择充值金额'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [10, 20, 50, 100, 200, 500].map((amount) {
                return ChoiceChip(
                  label: Text('¥$amount'),
                  selected: false,
                  onSelected: (selected) {
                    if (selected) {
                      Navigator.pop(context);
                      // TODO: 处理充值逻辑
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('充值 ¥$amount 功能开发中')),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }
}
