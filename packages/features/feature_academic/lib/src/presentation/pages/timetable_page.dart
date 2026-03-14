import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/academic_providers.dart';
import '../../data/models/course.dart';

/// 课程表页面
class AcademicTimetablePage extends ConsumerWidget {
  const AcademicTimetablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semester = ref.watch(selectedSemesterProvider);
    final coursesAsync = ref.watch(coursesProvider(semester));
    final currentWeek = ref.watch(currentWeekProvider);

    return coursesAsync.when(
      data: (courses) {
        if (courses.isEmpty) {
          return const EmptyWidget(title: '暂无课程数据');
        }
        return _TimetableView(courses: courses, currentWeek: currentWeek);
      },
      loading: () => const LoadingWidget(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(coursesProvider(semester)),
      ),
    );
  }
}

class _TimetableView extends StatelessWidget {
  final List<Course> courses;
  final int currentWeek;

  const _TimetableView({required this.courses, required this.currentWeek});

  static const _weekdays = ['一', '二', '三', '四', '五', '六', '日'];
  static const _sections = 12;

  @override
  Widget build(BuildContext context) {
    // 过滤当前周的课程
    final weekCourses = courses.where((c) => c.isInWeek(currentWeek)).toList();

    return Column(
      children: [
        _WeekHeader(currentWeek: currentWeek),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: _buildGrid(context, weekCourses),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<Course> weekCourses) {
    const cellWidth = 80.0;
    const cellHeight = 56.0;
    const timeWidth = 36.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 节次列
        Column(
          children: [
            SizedBox(height: 40), // 星期行高度
            ...List.generate(_sections, (i) {
              return Container(
                width: timeWidth,
                height: cellHeight,
                alignment: Alignment.center,
                child: Text(
                  '${i + 1}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              );
            }),
          ],
        ),
        // 每天一列
        ...List.generate(7, (dayIndex) {
          final weekday = dayIndex + 1;
          final dayCourses =
              weekCourses.where((c) => c.weekday == weekday).toList();

          return Column(
            children: [
              // 星期头
              Container(
                width: cellWidth,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Text(
                  '周${_weekdays[dayIndex]}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              // 课程格子
              SizedBox(
                width: cellWidth,
                height: cellHeight * _sections,
                child: Stack(
                  children: [
                    // 背景格子
                    ...List.generate(_sections, (i) {
                      return Positioned(
                        top: i * cellHeight,
                        left: 0,
                        right: 0,
                        height: cellHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade100),
                              right: BorderSide(color: Colors.grey.shade100),
                            ),
                          ),
                        ),
                      );
                    }),
                    // 课程块
                    ...dayCourses.map((course) {
                      final top = (course.startSection - 1) * cellHeight;
                      final height = course.sectionCount * cellHeight - 2;
                      return Positioned(
                        top: top + 1,
                        left: 2,
                        right: 2,
                        height: height,
                        child: _CourseCell(course: course),
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _WeekHeader extends ConsumerWidget {
  final int currentWeek;

  const _WeekHeader({required this.currentWeek});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      child: Row(
        children: [
          Text('第 $currentWeek 周',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            onPressed: currentWeek > 1
                ? () => ref.read(currentWeekProvider.notifier).state =
                    currentWeek - 1
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            onPressed: currentWeek < 20
                ? () => ref.read(currentWeekProvider.notifier).state =
                    currentWeek + 1
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _CourseCell extends StatelessWidget {
  final Course course;

  const _CourseCell({required this.course});

  @override
  Widget build(BuildContext context) {
    final color = _courseColor(course.name);
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.9),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (course.location.isNotEmpty)
            Text(
              course.location,
              style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Color _courseColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[name.hashCode.abs() % colors.length];
  }
}
