import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/convenience_providers.dart';
import '../../data/models/classroom.dart';

/// 教室查询页面
class ClassroomPage extends ConsumerWidget {
  const ClassroomPage({super.key});

  static const _types = [
    (value: null, label: '全部'),
    (value: 'lecture', label: '普通教室'),
    (value: 'lab', label: '实验室'),
    (value: 'computer', label: '机房'),
    (value: 'seminar', label: '研讨室'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBuilding = ref.watch(selectedBuildingProvider);
    final selectedType = ref.watch(selectedClassroomTypeProvider);
    final classroomsAsync = ref.watch(
      availableClassroomsProvider(
          (building: selectedBuilding, type: selectedType)),
    );
    final buildingsAsync = ref.watch(buildingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('空闲教室查询')),
      body: Column(
        children: [
          // 筛选栏
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                // 楼栋筛选
                Expanded(
                  child: buildingsAsync.maybeWhen(
                    data: (buildings) => DropdownButtonFormField<String?>(
                      value: selectedBuilding,
                      decoration: const InputDecoration(
                        labelText: '楼栋',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('全部楼栋')),
                        ...buildings.map((b) =>
                            DropdownMenuItem(value: b, child: Text(b))),
                      ],
                      onChanged: (v) =>
                          ref.read(selectedBuildingProvider.notifier).state = v,
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 12),
                // 类型筛选
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: '类型',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    items: _types
                        .map((t) =>
                            DropdownMenuItem(value: t.value, child: Text(t.label)))
                        .toList(),
                    onChanged: (v) => ref
                        .read(selectedClassroomTypeProvider.notifier)
                        .state = v,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 教室列表
          Expanded(
            child: classroomsAsync.when(
              data: (classrooms) {
                if (classrooms.isEmpty) {
                  return const EmptyWidget(message: '暂无空闲教室');
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(
                    availableClassroomsProvider(
                        (building: selectedBuilding, type: selectedType)),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: classrooms.length,
                    itemBuilder: (context, index) =>
                        _ClassroomCard(classroom: classrooms[index]),
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, _) => AppErrorWidget(
                error: error.toString(),
                onRetry: () => ref.invalidate(
                  availableClassroomsProvider(
                      (building: selectedBuilding, type: selectedType)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassroomCard extends StatelessWidget {
  final Classroom classroom;

  const _ClassroomCard({required this.classroom});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // 状态指示
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: classroom.isAvailable ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        classroom.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          classroom.typeText,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.business, size: 13, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(classroom.building,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(width: 12),
                      const Icon(Icons.people, size: 13, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${classroom.capacity}人',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  if (!classroom.isAvailable &&
                      classroom.currentCourse != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '当前：${classroom.currentCourse}',
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ],
                  if (classroom.isAvailable &&
                      classroom.nextOccupiedTime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '下次有课：${_formatTime(classroom.nextOccupiedTime!)}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.orange),
                    ),
                  ],
                ],
              ),
            ),
            // 空闲状态
            Text(
              classroom.isAvailable ? '空闲' : '占用',
              style: TextStyle(
                color: classroom.isAvailable ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
