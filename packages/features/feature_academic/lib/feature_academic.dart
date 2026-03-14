/// 学习工具功能模块
library feature_academic;

// Data 层
export 'src/data/models/course.dart';
export 'src/data/models/grade.dart';
export 'src/data/models/exam.dart';
export 'src/data/datasources/academic_api.dart';

// Presentation 层
export 'src/presentation/providers/academic_providers.dart';
export 'src/presentation/pages/academic_page.dart';
export 'src/presentation/pages/timetable_page.dart';
export 'src/presentation/pages/grades_page.dart';
export 'src/presentation/pages/exams_page.dart';
