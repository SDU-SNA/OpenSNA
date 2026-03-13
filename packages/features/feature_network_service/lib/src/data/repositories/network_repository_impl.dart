import '../../domain/repositories/network_repository.dart';
import '../datasources/network_service_api.dart';
import '../models/network_account.dart';
import '../models/device_info.dart';
import '../models/speed_test_result.dart';
import '../models/repair_record.dart';

/// 网络服务 Repository 实现
class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkServiceApi _api;

  NetworkRepositoryImpl(this._api);

  // ==================== 网络账号管理 ====================

  @override
  Future<NetworkAccount> getNetworkAccount() async {
    return await _api.getNetworkAccount();
  }

  @override
  Future<void> recharge(double amount) async {
    return await _api.recharge(amount);
  }

  @override
  Future<List<Map<String, dynamic>>> getTrafficHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _api.getTrafficHistory(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // ==================== 在线设备管理 ====================

  @override
  Future<List<DeviceInfo>> getOnlineDevices() async {
    return await _api.getOnlineDevices();
  }

  @override
  Future<DeviceInfo> getDeviceDetail(String deviceId) async {
    return await _api.getDeviceDetail(deviceId);
  }

  @override
  Future<void> offlineDevice(String deviceId) async {
    return await _api.offlineDevice(deviceId);
  }

  @override
  Future<void> offlineDevices(List<String> deviceIds) async {
    return await _api.offlineDevices(deviceIds);
  }

  // ==================== 网络测速 ====================

  @override
  Future<SpeedTestResult> startSpeedTest({String? server}) async {
    return await _api.startSpeedTest(server: server);
  }

  @override
  Future<List<SpeedTestResult>> getSpeedTestHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    return await _api.getSpeedTestHistory(
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getSpeedTestServers() async {
    return await _api.getSpeedTestServers();
  }

  // ==================== 故障报修 ====================

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
    return await _api.submitRepair(
      title: title,
      description: description,
      type: type,
      location: location,
      contact: contact,
      images: images,
      priority: priority,
    );
  }

  @override
  Future<String> uploadRepairImage(String filePath) async {
    return await _api.uploadRepairImage(filePath);
  }

  @override
  Future<List<RepairRecord>> getRepairRecords({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    return await _api.getRepairRecords(
      status: status,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<RepairRecord> getRepairDetail(String repairId) async {
    return await _api.getRepairDetail(repairId);
  }

  @override
  Future<void> cancelRepair(String repairId) async {
    return await _api.cancelRepair(repairId);
  }

  @override
  Future<void> rateRepair({
    required String repairId,
    required int rating,
    String? comment,
  }) async {
    return await _api.rateRepair(
      repairId: repairId,
      rating: rating,
      comment: comment,
    );
  }
}
