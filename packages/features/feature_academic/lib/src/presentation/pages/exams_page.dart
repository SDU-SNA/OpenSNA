import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/academic_providers.dart';
import '../../data/models/exam.dart';

class ExamsPage extends ConsumerWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semester = ref.watch(selectedSemesterProvider);
    final examsAsync = ref.watch(examsProvider(semester));

    return Scaffold(
      appBar: AppBar(
        title: const Text('考试安排'),
        actions: [_SemesterSelector()],
      ),
      body: examsAsync.when(
        data: (exams) {
          if (exams.isEmpty) return const EmptyWidget(title: '暂无考试安排');

          final upcoming = exams.where((e) => e.isUpcoming).toList()
            ..sort((a, b) => a.examTime.compareTo(b.examTime));
          final past = exams.where((e) => !e.isUpcoming).toList()
            ..sort((a, b) => b.examTime.compareTo(a.examTime));

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(examsProvider(semester)),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (upcoming.isNotEmpty) ...[
                  _SectionHeader(
                      title: '即将到来',
                      count: upcoming.length,
                      color: Colors.blue),
                  ...upcoming.map((e) => _ExamCard(exam: e)),
                  const SizedBox(height: 8),
                ],
                if (past.isNotEmpty) ...[
                  _SectionHeader(
                      title: '已结束', count: past.length, color: Colors.grey),
                  ...past.map((e) => _ExamCard(exam: e, isPast: true)),
                ],
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(examsProvider(semester)),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  const _SectionHeader(
      {required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10)),
            child: Text('$count', style: TextStyle(fontSize: 12, color: color)),
          ),
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final Exam exam;
  final bool isPast;
  const _ExamCard({required this.exam, this.isPast = false});

  @override
  Widget build(BuildContext context) {
    final daysLeft = exam.daysUntilExam;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exam.courseName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isPast ? Colors.grey : null,
                        ),
                  ),
                ),
                if (!isPast)
                  _CountdownBadge(daysLeft: daysLeft, isToday: exam.isToday)
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('已结束',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
                icon: Icons.access_time,
                text: _formatExamTime(exam),
                color: isPast ? Colors.grey : Colors.blue),
            const SizedBox(height: 6),
            _InfoRow(
                icon: Icons.location_on,
                text: exam.location,
                color: isPast ? Colors.grey : Colors.orange),
            const SizedBox(height: 6),
            _InfoRow(
                icon: Icons.event_seat,
                text: '座位号：${exam.seatNumber}',
                color: isPast ? Colors.grey : Colors.green),
            const SizedBox(height: 6),
            _InfoRow(
                icon: Icons.timer,
                text: '考试时长：${exam.durationMinutes} 分钟',
                color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _formatExamTime(Exam exam) {
    final t = exam.examTime;
    final end = exam.endTime;
    return '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')} '
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} - '
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }
}

class _CountdownBadge extends StatelessWidget {
  final int daysLeft;
  final bool isToday;
  const _CountdownBadge({required this.daysLeft, required this.isToday});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    if (isToday) {
      color = Colors.red;
      text = '今天';
    } else if (daysLeft <= 3) {
      color = Colors.orange;
      text = '$daysLeft天后';
    } else if (daysLeft <= 7) {
      color = Colors.blue;
      text = '$daysLeft天后';
    } else {
      color = Colors.grey;
      text = '$daysLeft天后';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.bold)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
            child: Text(text, style: TextStyle(fontSize: 13, color: color))),
      ],
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
