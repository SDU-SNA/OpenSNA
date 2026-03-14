import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/academic_providers.dart';
import '../../data/models/grade.dart';

/// 成绩查询页面
class GradesPage extends ConsumerWidget {
  const GradesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semester = ref.watch(selectedSemesterProvider);
    final gradesAsync = ref.watch(gradesProvider(semester));
    final stats = ref.watch(gpaStatsProvider(semester));

    return Scaffold(
      appBar: AppBar(
        title: const Text('成绩查询'),
        actions: [_SemesterSelector()],
      ),
      body: gradesAsync.when(
        data: (grades) {
          if (grades.isEmpty) {
            return const EmptyWidget(title: '暂无成绩数据');
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(gradesProvider(semester)),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _GpaCard(stats: stats)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _GradeCard(grade: grades[index]),
                      childCount: grades.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(gradesProvider(semester)),
        ),
      ),
    );
  }
}

class _GpaCard extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _GpaCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final gpa = stats['gpa'] as double;
    final total = stats['total'] as int;
    final passed = stats['passed'] as int;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
                value: gpa.toStringAsFixed(2),
                label: '平均绩点',
                color: _gpaColor(gpa)),
            _StatItem(value: '$total', label: '课程总数', color: Colors.blue),
            _StatItem(value: '$passed', label: '已通过', color: Colors.green),
            _StatItem(
              value: total > 0
                  ? '${(passed / total * 100).toStringAsFixed(0)}%'
                  : '-',
              label: '通过率',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Color _gpaColor(double gpa) {
    if (gpa >= 3.5) return Colors.green;
    if (gpa >= 2.5) return Colors.blue;
    if (gpa >= 1.5) return Colors.orange;
    return Colors.red;
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatItem(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _GradeCard extends StatelessWidget {
  final Grade grade;
  const _GradeCard({required this.grade});

  Color _scoreColor() {
    switch (grade.level) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.deepOrange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _scoreColor().withOpacity(0.15),
              ),
              alignment: Alignment.center,
              child: Text(
                grade.score,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _scoreColor()),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          grade.courseName,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (grade.type != 'normal')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(grade.typeText,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.orange)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${grade.credit} 学分',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(width: 12),
                      Text(grade.semester,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      if (grade.gpa != null) ...[
                        const SizedBox(width: 12),
                        Text(
                          'GPA ${grade.gpa!.toStringAsFixed(1)}',
                          style: TextStyle(
                              fontSize: 12,
                              color: _scoreColor(),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SemesterSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semestersAsync = ref.watch(semestersProvider);
    final selected = ref.watch(selectedSemesterProvider);

    return semestersAsync.maybeWhen(
      data: (semesters) => PopupMenuButton<String?>(
        icon: const Icon(Icons.filter_list),
        tooltip: '选择学期',
        initialValue: selected,
        onSelected: (value) =>
            ref.read(selectedSemesterProvider.notifier).state = value,
        itemBuilder: (_) => [
          const PopupMenuItem(value: null, child: Text('全部学期')),
          ...semesters.map((s) => PopupMenuItem(value: s, child: Text(s))),
        ],
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
