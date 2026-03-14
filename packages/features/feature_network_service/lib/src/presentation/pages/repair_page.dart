import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/network_providers.dart';
import '../../data/models/repair_record.dart';

/// 故障报修页面
class RepairPage extends ConsumerStatefulWidget {
  const RepairPage({super.key});

  @override
  ConsumerState<RepairPage> createState() => _RepairPageState();
}

class _RepairPageState extends ConsumerState<RepairPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('故障报修'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '提交报修'),
            Tab(text: '报修记录'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _SubmitRepairTab(),
          _RepairRecordsTab(),
        ],
      ),
    );
  }
}

/// 提交报修标签页
class _SubmitRepairTab extends ConsumerStatefulWidget {
  const _SubmitRepairTab();

  @override
  ConsumerState<_SubmitRepairTab> createState() => _SubmitRepairTabState();
}

class _SubmitRepairTabState extends ConsumerState<_SubmitRepairTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  String _selectedType = 'network_down';
  String _selectedPriority = 'normal';
  final List<String> _images = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submitRepair() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(repairServiceProvider.notifier);
    await notifier.submitRepair(
      title: _titleController.text,
      description: _descriptionController.text,
      type: _selectedType,
      location: _locationController.text,
      contact: _contactController.text,
      images: _images,
      priority: _selectedPriority,
    );

    final state = ref.read(repairServiceProvider);
    if (!mounted) return;

    state.when(
      data: (record) {
        if (record != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('报修提交成功')),
          );
          _formKey.currentState!.reset();
          _titleController.clear();
          _descriptionController.clear();
          _locationController.clear();
          _contactController.clear();
          setState(() {
            _images.clear();
            _selectedType = 'network_down';
            _selectedPriority = 'normal';
          });
        }
      },
      loading: () {},
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('提交失败: $error')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repairState = ref.watch(repairServiceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 故障类型
            Text(
              '故障类型',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'network_down',
                  label: Text('网络断开'),
                  icon: Icon(Icons.wifi_off),
                ),
                ButtonSegment(
                  value: 'slow_speed',
                  label: Text('网速慢'),
                  icon: Icon(Icons.speed),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'connection_issue',
                  label: Text('连接问题'),
                  icon: Icon(Icons.link_off),
                ),
                ButtonSegment(
                  value: 'other',
                  label: Text('其他'),
                  icon: Icon(Icons.more_horiz),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // 报修标题
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '报修标题',
                hintText: '请简要描述问题',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入报修标题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 问题描述
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '问题描述',
                hintText: '请详细描述遇到的问题',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入问题描述';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 报修位置
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: '报修位置',
                hintText: '例如：东校区1号楼101',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入报修位置';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 联系方式
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(
                labelText: '联系方式',
                hintText: '请输入手机号或邮箱',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入联系方式';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 优先级
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: const InputDecoration(
                labelText: '优先级',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('低')),
                DropdownMenuItem(value: 'normal', child: Text('普通')),
                DropdownMenuItem(value: 'high', child: Text('高')),
                DropdownMenuItem(value: 'urgent', child: Text('紧急')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPriority = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // 上传图片
            Text(
              '上传图片（可选）',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._images.map((image) => _ImagePreview(
                      imageUrl: image,
                      onRemove: () {
                        setState(() {
                          _images.remove(image);
                        });
                      },
                    )),
                if (_images.length < 5)
                  _AddImageButton(
                    onTap: () {
                      // TODO: 实现图片选择
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('图片上传功能开发中')),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: repairState.isLoading ? null : _submitRepair,
                child: repairState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('提交报修'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 图片预览组件
class _ImagePreview extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onRemove;

  const _ImagePreview({
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: onRemove,
          ),
        ),
      ],
    );
  }
}

/// 添加图片按钮
class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddImageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, color: Colors.grey),
            SizedBox(height: 4),
            Text('添加图片', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

/// 报修记录标签页
class _RepairRecordsTab extends ConsumerWidget {
  const _RepairRecordsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(
      repairRecordsProvider((status: null, page: 1, pageSize: 20)),
    );

    return recordsAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return const EmptyWidget(title: '暂无报修记录');
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(
              repairRecordsProvider((status: null, page: 1, pageSize: 20)),
            );
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return _RepairRecordCard(record: record);
            },
          ),
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(
        message: error.toString(),
        onRetry: () {
          ref.invalidate(
            repairRecordsProvider((status: null, page: 1, pageSize: 20)),
          );
        },
      ),
    );
  }
}

/// 报修记录卡片
class _RepairRecordCard extends StatelessWidget {
  final RepairRecord record;

  const _RepairRecordCard({required this.record});

  Color _getStatusColor() {
    switch (record.status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor() {
    switch (record.priority) {
      case 'low':
        return Colors.grey;
      case 'normal':
        return Colors.blue;
      case 'high':
        return Colors.orange;
      case 'urgent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: 导航到报修详情页
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('报修详情页面开发中')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和状态
              Row(
                children: [
                  Expanded(
                    child: Text(
                      record.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(record.statusText),
                    backgroundColor: _getStatusColor().withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 12,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 问题描述
              Text(
                record.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // 详细信息
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.category,
                    label: record.typeText,
                  ),
                  _InfoChip(
                    icon: Icons.priority_high,
                    label: record.priorityText,
                    color: _getPriorityColor(),
                  ),
                  _InfoChip(
                    icon: Icons.location_on,
                    label: record.location,
                  ),
                  _InfoChip(
                    icon: Icons.access_time,
                    label: _formatDate(record.createdAt),
                  ),
                ],
              ),

              // 处理信息
              if (record.handler != null) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '处理人员: ${record.handler}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],

              // 评价
              if (record.rating != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        index < record.rating! ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${record.rating}/5',
                      style: Theme.of(context).textTheme.bodySmall,
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
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}

/// 信息标签组件
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? Colors.grey),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color ?? Colors.grey,
              ),
        ),
      ],
    );
  }
}
