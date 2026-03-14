import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/network_providers.dart';
import '../../data/models/speed_test_result.dart';

/// 测速历史页面
class SpeedTestHistoryPage extends ConsumerStatefulWidget {
  const SpeedTestHistoryPage({super.key});

  @override
  ConsumerState<SpeedTestHistoryPage> createState() =>
      _SpeedTestHistoryPageState();
}

class _SpeedTestHistoryPageState extends ConsumerState<SpeedTestHistoryPage> {
  int _currentPage = 1;
  final int _pageSize = 20;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(
      speedTestHistoryProvider((page: _currentPage, pageSize: _pageSize)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('测速历史'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: 实现筛选功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('筛选功能开发中')),
              );
            },
          ),
        ],
      ),
      body: historyAsync.when(
        data: (results) {
          if (results.isEmpty) {
            return const EmptyWidget(message: '暂无测速记录');
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                speedTestHistoryProvider(
                    (page: _currentPage, pageSize: _pageSize)),
              );
            },
            child: Column(
              children: [
                // 统计信息
                _StatisticsCard(results: results),

                // 历史记录列表
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return _SpeedTestResultCard(result: result);
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(
          error: error.toString(),
          onRetry: () {
            ref.invalidate(
              speedTestHistoryProvider(
                  (page: _currentPage, pageSize: _pageSize)),
            );
          },
        ),
      ),
    );
  }
}

/// 统计信息卡片
class _StatisticsCard extends StatelessWidget {
  final List<SpeedTestResult> results;

  const _StatisticsCard({required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) return const SizedBox.shrink();

    // 计算平均值
    final avgDownload =
        results.map((r) => r.downloadSpeed).reduce((a, b) => a + b) /
            results.length;
    final avgUpload =
        results.map((r) => r.uploadSpeed).reduce((a, b) => a + b) /
            results.length;
    final avgPing =
        results.map((r) => r.ping).reduce((a, b) => a + b) / results.length;

    // 计算最高值
    final maxDownload =
        results.map((r) => r.downloadSpeed).reduce((a, b) => a > b ? a : b);
    final maxUpload =
        results.map((r) => r.uploadSpeed).reduce((a, b) => a > b ? a : b);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '统计信息',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: '平均下载',
                    value: '${avgDownload.toStringAsFixed(2)} Mbps',
                    icon: Icons.download,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '平均上传',
                    value: '${avgUpload.toStringAsFixed(2)} Mbps',
                    icon: Icons.upload,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: '平均延迟',
                    value: '${avgPing.toStringAsFixed(0)} ms',
                    icon: Icons.speed,
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '测速次数',
                    value: '${results.length}',
                    icon: Icons.history,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: '最高下载',
                    value: '${maxDownload.toStringAsFixed(2)} Mbps',
                    icon: Icons.trending_up,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: '最高上传',
                    value: '${maxUpload.toStringAsFixed(2)} Mbps',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 统计项组件
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

/// 测速结果卡片
class _SpeedTestResultCard extends StatelessWidget {
  final SpeedTestResult result;

  const _SpeedTestResultCard({required this.result});

  Color _getQualityColor() {
    switch (result.quality) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getQualityIcon() {
    switch (result.quality) {
      case 'excellent':
        return Icons.sentiment_very_satisfied;
      case 'good':
        return Icons.sentiment_satisfied;
      case 'fair':
        return Icons.sentiment_neutral;
      case 'poor':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final qualityColor = _getQualityColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showDetailDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 质量评级和时间
              Row(
                children: [
                  Icon(_getQualityIcon(), color: qualityColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    result.qualityText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: qualityColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(result.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 速度指标
              Row(
                children: [
                  Expanded(
                    child: _SpeedIndicator(
                      icon: Icons.download,
                      label: '下载',
                      value: result.downloadSpeed.toStringAsFixed(2),
                      unit: 'Mbps',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SpeedIndicator(
                      icon: Icons.upload,
                      label: '上传',
                      value: result.uploadSpeed.toStringAsFixed(2),
                      unit: 'Mbps',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SpeedIndicator(
                      icon: Icons.speed,
                      label: '延迟',
                      value: result.ping.toStringAsFixed(0),
                      unit: 'ms',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 服务器信息
              if (result.server != null) ...[
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.dns, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '服务器: ${result.server}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('测速详情'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: '质量评级', value: result.qualityText),
              _DetailRow(
                  label: '下载速度',
                  value: '${result.downloadSpeed.toStringAsFixed(2)} Mbps'),
              _DetailRow(
                  label: '上传速度',
                  value: '${result.uploadSpeed.toStringAsFixed(2)} Mbps'),
              _DetailRow(label: '延迟', value: '${result.ping.toInt()} ms'),
              _DetailRow(label: '抖动', value: '${result.jitter.toInt()} ms'),
              _DetailRow(
                  label: '丢包率', value: '${result.packetLoss.toInt()}%'),
              if (result.server != null)
                _DetailRow(label: '服务器', value: result.server!),
              _DetailRow(label: '测速时间', value: _formatFullDate(result.timestamp)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}分钟前';
      }
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  String _formatFullDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// 速度指标组件
class _SpeedIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _SpeedIndicator({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextSpan(
                text: ' $unit',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 详情行组件
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
