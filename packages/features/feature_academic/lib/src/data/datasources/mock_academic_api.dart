import 'dart:math';
import '../models/course.dart';
import '../models/grade.dart';
import '../models/exam.dart';

/// Mock 学术信息 API（用于开发/演示）
class MockAcademicApi {
  final _random = Random();

  Future<List<Course>> getCourses({String? semester}) async {
    await _delay();
    return [
      Course(
        id: 'c001',
        name: '高等数学（下）',
        teacher: '李教授',
        location: '知新楼A座101',
        credit: '4.0',
        weekday: 1,
        startSection: 1,
        sectionCount: 2,
        weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
        color: '#4CAF50',
      ),
      Course(
        id: 'c002',
        name: '大学物理（下）',
        teacher: '王教授',
        location: '物理楼201',
        credit: '3.0',
        weekday: 2,
        startSection: 3,
        sectionCount: 2,
        weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
        color: '#2196F3',
      ),
      Course(
        id: 'c003',
        name: '数据结构与算法',
        teacher: '张教授',
        location: '软件园实验楼302',
        credit: '3.5',
        weekday: 3,
        startSection: 1,
        sectionCount: 2,
        weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
        color: '#FF9800',
      ),
      Course(
        id: 'c004',
        name: '英语精读',
        teacher: 'Prof. Smith',
        location: '外语楼305',
        credit: '2.0',
        weekday: 4,
        startSection: 5,
        sectionCount: 2,
        weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
        color: '#9C27B0',
      ),
      Course(
        id: 'c005',
        name: '操作系统',
        teacher: '刘教授',
        location: '软件园实验楼201',
        credit: '3.0',
        weekday: 5,
        startSection: 3,
        sectionCount: 2,
        weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
        color: '#F44336',
      ),
      Course(
        id: 'c006',
        name: '体育（游泳）',
        teacher: '陈教练',
        location: '游泳馆',
        credit: '1.0',
        weekday: 3,
        startSection: 7,
        sectionCount: 2,
        weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
        color: '#00BCD4',
      ),
    ];
  }

  Future<List<Grade>> getGrades({String? semester}) async {
    await _delay();
    return [
      Grade(
        id: 'g001',
        courseName: '高等数学（上）',
        courseCode: 'MATH1001',
        credit: '4.0',
        score: '92',
        gpa: 4.0,
        semester: '2024-2025-1',
        type: 'normal',
      ),
      Grade(
        id: 'g002',
        courseName: '大学物理（上）',
        courseCode: 'PHYS1001',
        credit: '3.0',
        score: '85',
        gpa: 3.7,
        semester: '2024-2025-1',
        type: 'normal',
      ),
      Grade(
        id: 'g003',
        courseName: '程序设计基础',
        courseCode: 'CS1001',
        credit: '3.5',
        score: '96',
        gpa: 4.0,
        semester: '2024-2025-1',
        type: 'normal',
      ),
      Grade(
        id: 'g004',
        courseName: '线性代数',
        courseCode: 'MATH1003',
        credit: '3.0',
        score: '78',
        gpa: 3.3,
        semester: '2024-2025-1',
        type: 'normal',
      ),
      Grade(
        id: 'g005',
        courseName: '思想道德与法治',
        courseCode: 'POL1001',
        credit: '2.0',
        score: '88',
        gpa: 3.7,
        semester: '2024-2025-1',
        type: 'normal',
      ),
    ];
  }

  Future<List<Exam>> getExams({String? semester}) async {
    await _delay();
    final now = DateTime.now();
    return [
      Exam(
        id: 'e001',
        courseName: '高等数学（下）',
        courseCode: 'MATH1002',
        examTime: now.add(const Duration(days: 15, hours: 9)),
        durationMinutes: 120,
        location: '考试中心101',
        seatNumber: 'A-23',
        type: 'final',
      ),
      Exam(
        id: 'e002',
        courseName: '数据结构与算法',
        courseCode: 'CS2001',
        examTime: now.add(const Duration(days: 18, hours: 14)),
        durationMinutes: 120,
        location: '软件园考试楼201',
        seatNumber: 'B-15',
        type: 'final',
      ),
      Exam(
        id: 'e003',
        courseName: '大学物理（下）',
        courseCode: 'PHYS1002',
        examTime: now.add(const Duration(days: 20, hours: 9)),
        durationMinutes: 90,
        location: '物理楼考场301',
        seatNumber: 'C-08',
        type: 'final',
      ),
      Exam(
        id: 'e004',
        courseName: '操作系统',
        courseCode: 'CS3001',
        examTime: now.add(const Duration(days: 22, hours: 14)),
        durationMinutes: 120,
        location: '软件园考试楼101',
        seatNumber: 'A-31',
        type: 'final',
      ),
      Exam(
        id: 'e005',
        courseName: '英语精读',
        courseCode: 'ENG2001',
        examTime: now.subtract(const Duration(days: 30)),
        durationMinutes: 90,
        location: '外语楼考场201',
        seatNumber: 'B-22',
        type: 'midterm',
      ),
    ];
  }

  Future<List<String>> getSemesters() async {
    await _delay();
    return ['2024-2025-2', '2024-2025-1', '2023-2024-2', '2023-2024-1'];
  }

  Future<void> _delay() =>
      Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
}
