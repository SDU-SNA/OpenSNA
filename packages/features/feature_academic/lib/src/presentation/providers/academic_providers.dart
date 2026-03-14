import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_network/core_network.dart';
import '../../data/datasources/academic_api.dart';
import '../../data/models/course.dart';
import '../../data/models/grade.dart';
import '../../data/models/exam.dart';

final academicApiProvider = Provider<AcademicApi>((ref) {
  return AcademicApi(ApiClient());
});

/// 当前选中学期
final selectedSemesterProvider = StateProvider<String?>((ref) => null);

/// 当前周次
final currentWeekProvider = StateProvider<int>((ref) => 1);

/// 课程表 Provider
final coursesProvider =
    FutureProvider.family<List<Course>, String?>((ref, semester) async {
  return ref.watch(academicApiProvider).getCourses(semester: semester);
});

/// 成绩列表 Provider
final gradesProvider =
    FutureProvider.family<List<Grade>, String?>((ref, semester) async {
  return ref.watch(academicApiProvider).getGrades(semester: semester);
});

/// 考试安排 Provider
final examsProvider =
    FutureProvider.family<List<Exam>, String?>((ref, semester) async {
  return ref.watch(academicApiProvider).getExams(semester: semester);
});

/// 学期列表 Provider
final semestersProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(academicApiProvider).getSemesters();
});

/// 指定周次、星期的课程
final coursesForDayProvider =
    Provider.family<List<Course>, ({int week, int weekday})>((ref, params) {
  final semester = ref.watch(selectedSemesterProvider);
  final coursesAsync = ref.watch(coursesProvider(semester));
  return coursesAsync.maybeWhen(
    data: (courses) => courses
        .where((c) =>
            c.weekday == params.weekday && c.isInWeek(params.week))
        .toList()
      ..sort((a, b) => a.startSection.compareTo(b.startSection)),
    orElse: () => [],
  );
});

/// GPA 统计
final gpaStatsProvider = Provider.family<Map<String, dynamic>, String?>(
    (ref, semester) {
  final gradesAsync = ref.watch(gradesProvider(semester));
  return gradesAsync.maybeWhen(
    data: (grades) {
      if (grades.isEmpty) return {'gpa': 0.0, 'total': 0, 'passed': 0};
      final withGpa = grades.where((g) => g.gpa != null).toList();
      final avgGpa = withGpa.isEmpty
          ? 0.0
          : withGpa.map((g) => g.gpa!).reduce((a, b) => a + b) /
              withGpa.length;
      return {
        'gpa': double.parse(avgGpa.toStringAsFixed(2)),
        'total': grades.length,
        'passed': grades.where((g) => g.isPassed).length,
      };
    },
    orElse: () => {'gpa': 0.0, 'total': 0, 'passed': 0},
  );
});
