import 'package:flutter/material.dart';
import 'network_account_page.dart';
import 'device_manage_page.dart';
import 'speed_test_page.dart';
import 'repair_page.dart';

/// 网络服务主入口页面
class NetworkServicePage extends StatefulWidget {
  const NetworkServicePage({super.key});

  @override
  State<NetworkServicePage> createState() => _NetworkServicePageState();
}

class _NetworkServicePageState extends State<NetworkServicePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('网络服务'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(icon: Icon(Icons.account_circle_outlined), text: '账号'),
            Tab(icon: Icon(Icons.devices_outlined), text: '设备'),
            Tab(icon: Icon(Icons.speed_outlined), text: '测速'),
            Tab(icon: Icon(Icons.build_outlined), text: '报修'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          NetworkAccountPage(),
          DeviceManagePage(),
          SpeedTestPage(),
          RepairPage(),
        ],
      ),
    );
  }
}
