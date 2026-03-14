import 'package:flutter/material.dart';
import 'classroom_page.dart';
import 'library_page.dart';
import 'bus_page.dart';

/// 便民服务主入口页面
class ConveniencePage extends StatefulWidget {
  const ConveniencePage({super.key});

  @override
  State<ConveniencePage> createState() => _ConveniencePageState();
}

class _ConveniencePageState extends State<ConveniencePage>
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
        title: const Text('便民服务'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.meeting_room_outlined), text: '教室'),
            Tab(icon: Icon(Icons.local_library_outlined), text: '图书馆'),
            Tab(icon: Icon(Icons.directions_bus_outlined), text: '校车'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ClassroomPage(),
          LibraryPage(),
          BusPage(),
        ],
      ),
    );
  }
}
