import 'package:flutter/material.dart';
import 'timetable_page.dart';
import 'grades_page.dart';
import 'exams_page.dart';

/// 学习工具主入口页面
class AcademicPage extends StatefulWidget {
  const AcademicPage({super.key});

  @override
  State<AcademicPage> createState() => _AcademicPageState();
}

class _AcademicPageState extends State<AcademicPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('学习工具'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today_outlined), text: '课程表'),
            Tab(icon: Icon(Icons.grade_outlined), text: '成绩'),
            Tab(icon: Icon(Icons.assignment_outlined), text: '考试'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AcademicTimetablePage(),
          GradesPage(),
          ExamsPage(),
        ],
      ),
    );
  }
}
