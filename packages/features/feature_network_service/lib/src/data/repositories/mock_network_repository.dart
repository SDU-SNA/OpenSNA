import 'dart:math';
import '../../domain/repositories/network_repository.dart';
import '../models/network_account.dart';
import '../models/device_info.dart';
import '../models/speed_test_result.dart';
import '../models/repair_record.dart';

/// Mock 网络服务 Repository（用于开发/演示）
class MockNetworkRepository implements NetworkRepository {
  final _random = Random();

  @override
  Future<NetworkAccount> getNetworkAccount() async {
    await _delay();
    final now = DateTime.now();
    return NetworkAccount(
      id: 'mock_001',
      username: '202012345678',
      balance: 45.80,
      usedTraffic: 12.5,
      totalTraffic: 50.0,
      packageName: '校园网标准套餐',
      packagePrice: 30.0,
      expireTime: now.add(const Duration(days: 180)),
      status: 'active',
      createdAt: now.subtract(const Duration(days: 365)),
      updatedAt: now,
    );
  }

  @override
  Future<void> recharge(double amount) async {
    await _delay();
  }

  @override
  Future<List<Map<String, dynamic>>> getTrafficHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await _delay();
    return List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: i));
      return {
        'date': date.toIso8601String(),
        'upload': (_random.nextDouble() * 2).toStringAsFixed(2),
        'download': (_random.nextDouble() * 5).toStringAsFixed(2),
      };
    });
  }

  @override
  Future<List<DeviceInfo>> getOnlineDevices() async {
    await _delay();
    final now = DateTime.now();
    return [
      DeviceInfo(
        id: 'dev_001',
        name: 'iPhone 15 Pro',
        type: 'phone',
        macAddress: 'AA:BB:CC:DD:EE:01',
        ipAddress: '10.0.1.101',
        loginTime: now.subtract(const Duration(hours: 2)),
        lastActiveTime: now.subtract(const Duration(minutes: 5)),
        usedTraffic: 256.5,
        os: 'iOS 17',
        brand: 'Apple',
        model: 'iPhone 15 Pro',
        isCurrentDevice: true,
      ),
      DeviceInfo(
        id: 'dev_002',
        name: 'MacBook Pro',
        type: 'laptop',
        macAddress: 'AA:BB:CC:DD:EE:02',
        ipAddress: '10.0.1.102',
        loginTime: now.subtract(const Duration(hours: 5)),
        lastActiveTime: now.subtract(const Duration(minutes: 30)),
        usedTraffic: 1024.0,
        os: 'macOS 14',
        brand: 'Apple',
        model: 'MacBook Pro',
        isCurrentDevice: false,
      ),
      DeviceInfo(
        id: 'dev_003',
        name: 'iPad Air',
        type: 'tablet',
        macAddress: 'AA:BB:CC:DD:EE:03',
        ipAddress: '10.0.1.103',
        loginTime: now.subtract(const Duration(days: 1)),
        lastActiveTime: now.subtract(const Duration(hours: 3)),
        usedTraffic: 512.0,
        os: 'iPadOS 17',
        brand: 'Apple',
        model: 'iPad Air',
        isCurrentDevice: false,
      ),
    ];
  }

  @override
  Future<DeviceInfo> getDeviceDetail(String deviceId) async {
    final devices = await getOnlineDevices();
    return devices.firstWhere((d) => d.id == deviceId);
  }

  @override
  Future<void> offlineDevice(String deviceId) async {
    await _delay();
  }

  @override
  Future<void> offlineDevices(List<String> deviceIds) async {
    await _delay();
  }

  @override
  Future<SpeedTestResult> startSpeedTest({String? server}) async {
    await Future.delayed(const Duration(seconds: 3));
    return SpeedTestResult(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      downloadSpeed: 80 + _random.nextDouble() * 40,
      uploadSpeed: 20 + _random.nextDouble() * 20,
      latency: 10 + _random.nextInt(30),
      jitter: _random.nextInt(10),
      packetLoss: _random.nextDouble() * 0.5,
      server: server ?? '山东大学中心节点',
      testTime: DateTime.now(),
      networkType: 'wifi',
      status: 'success',
    );
  }

  @override
  Future<List<SpeedTestResult>> getSpeedTestHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    await _delay();
    return List.generate(pageSize, (i) {
      final index = (page - 1) * pageSize + i;
      return SpeedTestResult(
        id: 'hist_$index',
        downloadSpeed: 60 + _random.nextDouble() * 60,
        uploadSpeed: 15 + _random.nextDouble() * 25,
        latency: 8 + _random.nextInt(40),
        jitter: _random.nextInt(15),
        packetLoss: _random.nextDouble() * 1.0,
        server: ['山东大学中心节点', '济南教育网节点', '青岛节点'][index % 3],
        testTime: DateTime.now().subtract(Duration(hours: index * 3)),
        networkType: ['wifi', 'ethernet'][index % 2],
        status: 'success',
      );
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getSpeedTestServers() async {
    await _delay();
    return [
      {'id': 'server_1', 'name': '山东大学中心节点', 'location': '济南'},
      {'id': 'server_2', 'name': '济南教育网节点', 'location': '济南'},
      {'id': 'server_3', 'name': '青岛节点', 'location': '青岛'},
    ];
  }

  @override
  Future<RepairRecord> submitRepair({
    required String title,
    required String description,
    required String type,
    required String location,
    required String contact,
    List<String>? images,
    String priority = 'normal',
  }) async {
    await _delay();
    final now = DateTime.now();
    return RepairRecord(
      id: 'repair_${now.millisecondsSinceEpoch}',
      title: title,
      description: description,
      type: type,
      location: location,
      contact: contact,
      images: images ?? [],
      status: 'pending',
      priority: priority,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<String> uploadRepairImage(String filePath) async {
    await _delay();
    return 'https://mock.cdn.sdu.edu.cn/repair/mock_image.jpg';
  }

  @override
  Future<List<RepairRecord>> getRepairRecords({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    await _delay();
    final statuses = ['pending', 'processing', 'resolved', 'closed'];
    return List.generate(5, (i) {
      final now = DateTime.now();
      return RepairRecord(
        id: 'repair_00$i',
        title: ['宿舍网络断网', '网速异常缓慢', '无法连接校园网', '网络设备故障', 'WiFi信号弱'][i],
        description: '详细描述 $i：网络出现问题，请尽快处理。',
        type: [
          'network_down',
          'slow_speed',
          'connection_issue',
          'other',
          'slow_speed'
        ][i],
        location: ['知新楼A座301', '宿舍楼3号楼205', '图书馆二楼', '教学楼B座', '实验楼'][i],
        contact: '138****${1000 + i}',
        images: [],
        status: status ?? statuses[i % statuses.length],
        priority: ['urgent', 'high', 'normal', 'normal', 'low'][i],
        createdAt: now.subtract(Duration(days: i * 2)),
        updatedAt: now.subtract(Duration(days: i)),
      );
    });
  }

  @override
  Future<RepairRecord> getRepairDetail(String repairId) async {
    final records = await getRepairRecords();
    return records.firstWhere(
      (r) => r.id == repairId,
      orElse: () => records.first,
    );
  }

  @override
  Future<void> cancelRepair(String repairId) async {
    await _delay();
  }

  @override
  Future<void> rateRepair({
    required String repairId,
    required int rating,
    String? comment,
  }) async {
    await _delay();
  }

  Future<void> _delay() =>
      Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
}
