import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/network_providers.dart';
import '../../data/models/speed_test_result.dart';

/// 网络测速页面
class SpeedTestPage extends ConsumerStatefulWidget {
  const SpeedTestPage({super.key});

  @override
  ConsumerState<SpeedTestPage> createState() => _SpeedTestPageState();
}

class _SpeedTestPageState extends ConsumerState<SpeedTestPage> {
  @override
  Widget build(BuildContext context) {
    final speedTestState = ref.watch(speedTestProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('网络测速'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: 跳转到测速历史页面
            },
            tooltip: '测速历史',
          ),
        ],
      ),
      body: SafeArea(
        child: speedTestState.when(
          data: (result) => result == null
              ? _buildIdleState()
              : _buildResultState(result),
          loading: () => _buildTestingState(),
          error: (error, stack) => _buildErrorState(error.toString()),
        ),
      ),
    );
  }

  /// 空闲状态（未开始测速）
  Widget _buildIdleState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 测速图标
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.primary.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              Icons.speed,
              size: 100,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 40),
          // 提示文本
          Text(
            '点击下方按钮开始测速',
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '测试将包括下载速度、上传速度和延迟',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 60),
          // 开始测速按钮
          ElevatedButton(
            onPressed: _startSpeedTest,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              '开始测速',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  /// 测速中状态
  Widget _buildTestingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 加载动画
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 外圈动画
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                // 内圈图标
                Icon(
                  Icons.speed,
                  size: 80,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // 测速提示
          Text(
            '正在测速中...',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '请保持网络连接稳定',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 测速结果状态
  Widget _buildResultState(SpeedTestResult result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 质量评级卡片
          _buildQualityCard(result),
          const SizedBox(height: 16),
          // 速度指标卡片
          _buildSpeedMetrics(result),
          const SizedBox(height: 16),
          // 网络指标卡片
          _buildNetworkMetrics(result),
          const SizedBox(height: 16),
          // 测试信息
          _buildTestInfo(result),
          const SizedBox(height: 24),
          // 重新测速按钮
          ElevatedButton(
            onPressed: _startSpeedTest,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('重新测速'),
          ),
        ],
      ),
    );
  }

  /// 质量评级卡片
  Widget _buildQualityCard(SpeedTestResult result) {
    Color qualityColor;
    IconData qualityIcon;

    switch (result.qualityRating) {
      case 'excellent':
        qualityColor = AppColors.success;
        qualityIcon = Icons.sentiment_very_satisfied;
        break;
      case 'good':
        qualityColor = Colors.green;
        qualityIcon = Icons.sentiment_satisfied;
        break;
      case 'fair':
        qualityColor = AppColors.warning;
        qualityIcon = Icons.sentiment_neutral;
        break;
      case 'poor':
        qualityColor = AppColors.error;
        qualityIcon = Icons.sentiment_dissatisfied;
        break;
      default:
        qualityColor = AppColors.textSecondary;
        qualityIcon = Icons.help_outline;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              qualityIcon,
              size: 80,
              color: qualityColor,
            ),
            const SizedBox(height: 16),
            Text(
              result.qualityRatingText,
              style: AppTextStyles.headlineMedium.copyWith(
                color: qualityColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '网络质量评级',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 速度指标卡片
  Widget _buildSpeedMetrics(SpeedTestResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '速度指标',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.download,
                    label: '下载速度',
                    value: result.formattedDownloadSpeed,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.upload,
                    label: '上传速度',
                    value: result.formattedUploadSpeed,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 网络指标卡片
  Widget _buildNetworkMetrics(SpeedTestResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '网络指标',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.timer,
                    label: '延迟',
                    value: result.formattedLatency,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.graphic_eq,
                    label: '抖动',
                    value: result.formattedJitter,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMetricItem(
              icon: Icons.signal_cellular_alt,
              label: '丢包率',
              value: result.formattedPacketLoss,
              color: result.packetLoss > 0 ? AppColors.error : AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  /// 指标项
  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
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

  /// 测试信息
  Widget _buildTestInfo(SpeedTestResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '测试信息',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('测试服务器', result.server),
            _buildInfoRow('网络类型', _getNetworkTypeText(result.networkType)),
            _buildInfoRow(
              '测试时间',
              '${result.testTime.year}-${result.testTime.month.toString().padLeft(2, '0')}-${result.testTime.day.toString().padLeft(2, '0')} '
                  '${result.testTime.hour.toString().padLeft(2, '0')}:${result.testTime.minute.toString().padLeft(2, '0')}',
            ),
          ],
        ),
      ),
    );
  }

  /// 信息行
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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

  /// 错误状态
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.error,
          ),
          const SizedBox(height: 24),
          Text(
            '测速失败',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _startSpeedTest,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 开始测速
  void _startSpeedTest() {
    ref.read(speedTestProvider.notifier).startSpeedTest();
  }

  /// 获取网络类型文本
  String _getNetworkTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'wifi':
        return 'Wi-Fi';
      case 'cellular':
        return '移动网络';
      case 'ethernet':
        return '以太网';
      default:
        return '未知';
    }
  }
}
