import 'package:core_network/core_network.dart';
import '../models/network_account.dart';
import '../models/device_info.dart';
import '../models/speed_test_result.dart';
import '../models/repair_record.dart';

/// 网络服务 API
class NetworkServiceApi {
  final ApiClient _apiClient;

  NetworkServiceApi(this._apiClient);

  // ==================== 网络账号管理 ====================

  /// 获取网络账号信息
  Future<NetworkAccount> getNetworkAccount() async {
    final response = await _apiClient.get('/api/network/account');
    return NetworkAccount.fromJson(response.data);
  }

  /// 充值
  Future<void> recharge(double amount) async {
    await _apiClient.post(
      '/api/network/account/recharge',
      data: {'amount': amount},
    );
  }

  /// 获取流量使用历史
  Future<List<Map<String, dynamic>>> getTrafficHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _apiClient.get(
      '/api/network/account/traffic-history',
      queryParameters: {
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      },
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  // ==================== 在线设备管理 ====================

  /// 获取在线设备列表
  Future<List<DeviceInfo>> getOnlineDevices() async {
    final response = await _apiClient.get('/api/network/devices');
    return (response.data as List)
        .map((json) => DeviceInfo.fromJson(json))
        .toList();
  }

  /// 获取设备详情
  Future<DeviceInfo> getDeviceDetail(String deviceId) async {
    final response = await _apiClient.get('/api/network/devices/$deviceId');
    return DeviceInfo.fromJson(response.data);
  }

  /// 下线设备
  Future<void> offlineDevice(String deviceId) async {
    await _apiClient.post('/api/network/devices/$deviceId/offline');
  }

  /// 批量下线设备
  Future<void> offlineDevices(List<String> deviceIds) async {
    await _apiClient.post(
      '/api/network/devices/batch-offline',
      data: {'device_ids': deviceIds},
    );
  }

  // ==================== 网络测速 ====================

  /// 开始测速
  Future<SpeedTestResult> startSpeedTest({
    String? server,
  }) async {
    final response = await _apiClient.post(
      '/api/network/speed-test/start',
      data: {
        if (server != null) 'server': server,
      },
    );
    return SpeedTestResult.fromJson(response.data);
  }

  /// 获取测速历史
  Future<List<SpeedTestResult>> getSpeedTestHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      '/api/network/speed-test/history',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return (response.data as List)
        .map((json) => SpeedTestResult.fromJson(json))
        .toList();
  }

  /// 获取测速服务器列表
  Future<List<Map<String, dynamic>>> getSpeedTestServers() async {
    final response = await _apiClient.get('/api/network/speed-test/servers');
    return List<Map<String, dynamic>>.from(response.data);
  }

  // ==================== 故障报修 ====================

  /// 提交报修
  Future<RepairRecord> submitRepair({
    required String title,
    required String description,
    required String type,
    required String location,
    required String contact,
    List<String>? images,
    String priority = 'normal',
  }) async {
    final response = await _apiClient.post(
      '/api/network/repair/submit',
      data: {
        'title': title,
        'description': description,
        'type': type,
        'location': location,
        'contact': contact,
        if (images != null && images.isNotEmpty) 'images': images,
        'priority': priority,
      },
    );
    return RepairRecord.fromJson(response.data);
  }

  /// 上传报修图片
  Future<String> uploadRepairImage(String filePath) async {
    // 使用 multipart 上传
    final response = await _apiClient.post(
      '/api/network/repair/upload-image',
      data: {'file_path': filePath},
    );
    return response.data['url'] as String? ?? '';
  }

  /// 获取报修记录列表
  Future<List<RepairRecord>> getRepairRecords({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      '/api/network/repair/records',
      queryParameters: {
        if (status != null) 'status': status,
        'page': page,
        'page_size': pageSize,
      },
    );
    return (response.data as List)
        .map((json) => RepairRecord.fromJson(json))
        .toList();
  }

  /// 获取报修详情
  Future<RepairRecord> getRepairDetail(String repairId) async {
    final response = await _apiClient.get('/api/network/repair/$repairId');
    return RepairRecord.fromJson(response.data);
  }

  /// 取消报修
  Future<void> cancelRepair(String repairId) async {
    await _apiClient.post('/api/network/repair/$repairId/cancel');
  }

  /// 评价报修
  Future<void> rateRepair({
    required String repairId,
    required int rating,
    String? comment,
  }) async {
    await _apiClient.post(
      '/api/network/repair/$repairId/rate',
      data: {
        'rating': rating,
        if (comment != null) 'comment': comment,
      },
    );
  }
}
