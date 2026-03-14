import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/network_providers.dart';
import '../../data/models/speed_test_result.dart';
import 'speed_test_history_page.dart';

/// 网络测速页面
class SpeedTestPage extends ConsumerWidget {
  const SpeedTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speedTestState = ref.watch(speedTestProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('网络测速'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: '测速历史',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SpeedTestHistoryPage()),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SpeedGauge(state: speedTestState),
              const SizedBox(height: 32),
              speedTestState.when(
                data: (result) => result != null
                    ? _ResultCard(result: result)
                    : const _IdleHint(),
                loading: () => const _TestingIndicator(),
                error: (e, _) => AppErrorWidget(
                  message: e.toString(),
                  onRetry: () => ref.read(speedTestProvider.notifier).reset(),
                ),
              ),
              const SizedBox(height: 32),
              _ActionButton(state: speedTestState),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedGauge extends StatelessWidget {
  final AsyncValue<SpeedTestResult?> state;

  const _SpeedGauge({required this.state});

  @override
  Widget build(BuildContext context) {
    final isLoading = state.isLoading;
    final result = state.valueOrNull;

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 3,
        ),
      ),
      child: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('测速中...'),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.speed,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result != null
                        ? '${result.downloadSpeed.toStringAsFixed(1)}'
                        : '--',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  Text(
                    'Mbps',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}

class _IdleHint extends StatelessWidget {
  const _IdleHint();

  @override
  Widget build(BuildContext context) {
    return Text(
      '点击下方按钮开始测速',
      style:
          Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
    );
  }
}

class _TestingIndicator extends StatelessWidget {
  const _TestingIndicator();

  @override
  Widget build(BuildContext context) {
    return Text(
      '正在测试网络速度，请稍候...',
      style:
          Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final SpeedTestResult result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              result.qualityRatingText,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _qualityColor(result.qualityRating),
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                    icon: Icons.download,
                    label: '下载',
                    value: '${result.downloadSpeed.toStringAsFixed(2)} Mbps',
                    color: Colors.blue),
                _MetricItem(
                    icon: Icons.upload,
                    label: '上传',
                    value: '${result.uploadSpeed.toStringAsFixed(2)} Mbps',
                    color: Colors.green),
                _MetricItem(
                    icon: Icons.timer_outlined,
                    label: '延迟',
                    value: '${result.latency} ms',
                    color: Colors.orange),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '服务器：${result.server}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Color _qualityColor(String rating) {
    switch (rating) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'fair':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricItem(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class _ActionButton extends ConsumerWidget {
  final AsyncValue<SpeedTestResult?> state;

  const _ActionButton({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = state.isLoading;
    final hasResult = state.valueOrNull != null;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isLoading
                ? null
                : () => ref.read(speedTestProvider.notifier).startSpeedTest(),
            icon: const Icon(Icons.play_arrow),
            label: Text(hasResult ? '重新测速' : '开始测速'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        if (hasResult) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => ref.read(speedTestProvider.notifier).reset(),
            child: const Text('清除结果'),
          ),
        ],
      ],
    );
  }
}
