import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/network_providers.dart';
import '../../data/models/device_info.dart';

/// 在线设备管理页面
class DeviceManagePage extends ConsumerWidget {
  const DeviceManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesState = ref.watch(onlineDevicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('在线设备'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(onlineDevicesProvider);
            },
            tooltip: '刷新',
          ),
        ],
      ),
      body: devicesState.when(
        data: (devices) => _buildContent(context, ref, devices),
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(onlineDevicesProvider);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, List<DeviceInfo> devices) {
    if (devices.isEmpty) {
      return const EmptyWidget(title: '暂无在线设备');
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(onlineDevicesProvider);
        await ref.read(onlineDevicesProvider.future);
      },
      child: Column(
        children: [
          // 设备统计
          _buildDeviceStats(devices),
          // 设备列表
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: devices.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final device = devices[index];
                return _buildDeviceCard(context, ref, device);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 设备统计
  Widget _buildDeviceStats(List<DeviceInfo> devices) {
    final totalTraffic = devices.fold<double>(
      0,
      (sum, device) => sum + device.usedTraffic,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.devices,
            label: '在线设备',
            value: '${devices.length}',
            color: AppColors.primary,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
          ),
          _buildStatItem(
            icon: Icons.cloud_download,
            label: '总流量',
            value: totalTraffic < 1024
                ? '${totalTraffic.toStringAsFixed(0)} MB'
                : '${(totalTraffic / 1024).toStringAsFixed(2)} GB',
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  /// 统计项
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
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
    );
  }

  /// 设备卡片
  Widget _buildDeviceCard(
      BuildContext context, WidgetRef ref, DeviceInfo device) {
    return Card(
      child: InkWell(
        onTap: () {
          _showDeviceDetail(context, ref, device);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 设备头部
              Row(
                children: [
                  // 设备图标
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getDeviceIcon(device.type),
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 设备信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                device.displayName,
                                style: AppTextStyles.labelLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (device.isCurrentDevice)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.success.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '当前设备',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          device.ipAddress,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              // 设备详情
              Row(
                children: [
                  Expanded(
                    child: _buildDeviceInfo(
                      icon: Icons.access_time,
                      label: '在线时长',
                      value: device.formattedOnlineDuration,
                    ),
                  ),
                  Expanded(
                    child: _buildDeviceInfo(
                      icon: Icons.cloud_download,
                      label: '已用流量',
                      value: device.formattedTraffic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 操作按钮
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showDeviceDetail(context, ref, device);
                      },
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('详情'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: device.isCurrentDevice
                          ? null
                          : () {
                              _confirmOfflineDevice(context, ref, device);
                            },
                      icon: const Icon(Icons.power_settings_new, size: 18),
                      label: const Text('下线'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 设备信息项
  Widget _buildDeviceInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 获取设备图标
  IconData _getDeviceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'phone':
        return Icons.phone_android;
      case 'tablet':
        return Icons.tablet;
      case 'laptop':
        return Icons.laptop;
      case 'desktop':
        return Icons.computer;
      default:
        return Icons.devices;
    }
  }

  /// 显示设备详情
  void _showDeviceDetail(
      BuildContext context, WidgetRef ref, DeviceInfo device) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '设备详情',
                      style: AppTextStyles.headlineSmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 详情列表
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailItem('设备名称', device.displayName),
                    _buildDetailItem('设备类型', _getDeviceTypeText(device.type)),
                    _buildDetailItem('MAC地址', device.macAddress),
                    _buildDetailItem('IP地址', device.ipAddress),
                    _buildDetailItem('登录时间', _formatDateTime(device.loginTime)),
                    _buildDetailItem(
                        '最后活跃', _formatDateTime(device.lastActiveTime)),
                    _buildDetailItem('在线时长', device.formattedOnlineDuration),
                    _buildDetailItem('已用流量', device.formattedTraffic),
                    if (device.os != null) _buildDetailItem('操作系统', device.os!),
                    if (device.brand != null)
                      _buildDetailItem('品牌', device.brand!),
                    if (device.model != null)
                      _buildDetailItem('型号', device.model!),
                    if (device.location != null)
                      _buildDetailItem('位置', device.location!),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 操作按钮
              if (!device.isCurrentDevice)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmOfflineDevice(context, ref, device);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('下线设备'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 详情项
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// 确认下线设备
  void _confirmOfflineDevice(
      BuildContext context, WidgetRef ref, DeviceInfo device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认下线'),
        content: Text('确定要下线设备 "${device.displayName}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _offlineDevice(context, ref, device);
            },
            child: Text(
              '确定',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// 下线设备
  Future<void> _offlineDevice(
      BuildContext context, WidgetRef ref, DeviceInfo device) async {
    try {
      await ref.read(deviceManageProvider.notifier).offlineDevice(device.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('设备已下线')),
        );
        // 刷新设备列表
        ref.invalidate(onlineDevicesProvider);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('下线失败: $e')),
        );
      }
    }
  }

  /// 获取设备类型文本
  String _getDeviceTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'phone':
        return '手机';
      case 'tablet':
        return '平板';
      case 'laptop':
        return '笔记本';
      case 'desktop':
        return '台式机';
      default:
        return '其他';
    }
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
