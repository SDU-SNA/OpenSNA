import 'package:core_network/core_network.dart';
import '../models/course.dart';
import '../models/grade.dart';
import '../models/exam.dart';

/// 学术信息 API 数据源
class AcademicApi {
  final ApiClient _apiClient;

  AcademicApi(this._apiClient);

  /// 获取课程表（当前学期）
  Future<List<Course>> getCourses({String? semester}) async {
    final response = await _apiClient.get(
      '/academic/courses',
      queryParameters: {if (semester != null) 'semester': semester},
    );
    final data = response.data as List;
    return data
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 获取成绩列表
  Future<List<Grade>> getGrades({String? semester}) async {
    final response = await _apiClient.get(
      '/academic/grades',
      queryParameters: {if (semester != null) 'semester': semester},
    );
    final data = response.data as List;
    return data
        .map((e) => Grade.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 获取考试安排
  Future<List<Exam>> getExams({String? semester}) async {
    final response = await _apiClient.get(
      '/academic/exams',
      queryParameters: {if (semester != null) 'semester': semester},
    );
    final data = response.data as List;
    return data
        .map((e) => Exam.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 获取可选学期列表
  Future<List<String>> getSemesters() async {
    final response = await _apiClient.get('/academic/semesters');
    return (response.data as List).map((e) => e as String).toList();
  }
}
