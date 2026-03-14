import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/academic_providers.dart';
import '../../data/models/course.dart';

/// 课程表页面
class AcademicTimetablePage extends ConsumerStatefulWidget {
  const AcademicTimetablePage({super.key});

  @override
  ConsumerState<AcademicTimetablePage> createState() =>
      _AcademicTimetablePageState();
}

class _AcademicTimetablePageState
    extends ConsumerState<AcademicTimetablePage> {
  late PageController _pageController;

  // 每节课的时间段
  static const _sectionTimes = [
    '08:00\n08:50',
    '09:00\n09:50',
    '10:10\n11:00',
    '11:10\n12:00',
    '14:00\n14:50',
    '15:00\n15:50',
    '16:10\n17:00',
    '17:10\n18:00',
    '19:00\n19:50',
    '20:00\n20:50',
    '21:00\n21:50',
  ];

  static const _weekdays = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  void initState() {
    super.initState();
    final currentWeek = ref.read(currentWeekProvider);
    _pageController = PageController(initialPage: currentWeek - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWeek = ref.watch(currentWeekProvider);
    final semester = ref.watch(selectedSemesterProvider);
    final coursesAsync = ref.watch(coursesProvider(semester));

    return Scaffold(
      appBar: AppBar(
        title: Text('第 $currentWeek 周'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: '回到本周',
            onPressed: () {
              _pageController.animateToPage(
                currentWeek - 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
      body: coursesAsync.when(
        data: (courses) => Column(
          children: [
            // 星期标题行
            _WeekdayHeader(currentWeek: currentWeek),
            // 课程表主体（可左右滑动切换周次）
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  ref.read(currentWeekProvider.notifier).state = page + 1;
                },
                itemCount: 20, // 最多20周
                itemBuilder: (context, pageIndex) {
                  final week = pageIndex + 1;
                  return _TimetableGrid(
                    week: week,
                    courses: courses,
                    sectionTimes: _sectionTimes,
                    weekdays: _weekdays,
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const LoadingWidget(),
        error: (error, _) => AppErrorWidget(
          error: error.toString(),
          onRetry: () => ref.invalidate(coursesProvider(semester)),
        ),
      ),
    );
  }
}

/// 星期标题行
class _WeekdayHeader extends StatelessWidget {
  final int currentWeek;
  static const _weekdays = ['一', '二', '三', '四', '五', '六', '日'];

  const _WeekdayHeader({required this.currentWeek});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayWeekday = now.weekday; // 1=周一

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          // 时间列占位
          const SizedBox(width: 40),
          // 星期列
          ...List.generate(7, (i) {
            final isToday = i + 1 == todayWeekday;
            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: isToday
                    ? BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      )
                    : null,
                child: Column(
                  children: [
                    Text(
                      '周${_weekdays[i]}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isToday
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// 课程表网格
class _TimetableGrid extends StatelessWidget {
  final int week;
  final List<Course> courses;
  final List<String> sectionTimes;
  final List<String> weekdays;

  const _TimetableGrid({
    required this.week,
    required this.courses,
    required this.sectionTimes,
    required this.weekdays,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 节次时间列
          SizedBox(
            width: 40,
            child: Column(
              children: List.generate(sectionTimes.length, (i) {
                return Container(
                  height: 64,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${i + 1}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        sectionTimes[i],
                        style: const TextStyle(
                            fontSize: 9, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // 7天课程列
          ...List.generate(7, (dayIndex) {
            final weekday = dayIndex + 1;
            final dayCourses = courses
                .where((c) => c.weekday == weekday && c.isInWeek(week))
                .toList();

            return Expanded(
              child: SizedBox(
                height: 64.0 * sectionTimes.length,
                child: Stack(
                  children: [
                    // 背景格子
                    Column(
                      children: List.generate(
                        sectionTimes.length,
                        (_) => Container(
                          height: 64,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              right: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 课程块
                    ...dayCourses.map((course) => _CourseBlock(
                          course: course,
                          cellHeight: 64,
                        )),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// 课程块
class _CourseBlock extends StatelessWidget {
  final Course course;
  final double cellHeight;

  const _CourseBlock({required this.course, required this.cellHeight});

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(course.color);
    final top = (course.startSection - 1) * cellHeight + 2;
    final height = course.sectionCount * cellHeight - 4;

    return Positioned(
      top: top,
      left: 2,
      right: 2,
      height: height,
      child: GestureDetector(
        onTap: () => _showCourseDetail(context),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.85),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (height > 80) ...[
                const SizedBox(height: 2),
                Text(
                  course.location,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCourseDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 16),
            _DetailRow(icon: Icons.person, label: '教师', value: course.teacher),
            _DetailRow(
                icon: Icons.location_on, label: '地点', value: course.location),
            _DetailRow(
                icon: Icons.school,
                label: '学分',
                value: course.credit),
            _DetailRow(
                icon: Icons.access_time,
                label: '时间',
                value:
                    '周${['一', '二', '三', '四', '五', '六', '日'][course.weekday - 1]} '
                    '第${course.startSection}-${course.endSection}节'),
            _DetailRow(
                icon: Icons.calendar_month,
                label: '周次',
                value: _formatWeeks(course.weeks)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _formatWeeks(List<int> weeks) {
    if (weeks.isEmpty) return '';
    final sorted = [...weeks]..sort();
    final ranges = <String>[];
    int start = sorted[0], end = sorted[0];
    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i] == end + 1) {
        end = sorted[i];
      } else {
        ranges.add(start == end ? '$start' : '$start-$end');
        start = end = sorted[i];
      }
    }
    ranges.add(start == end ? '$start' : '$start-$end');
    return '${ranges.join(', ')}周';
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.blue;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label：',
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
