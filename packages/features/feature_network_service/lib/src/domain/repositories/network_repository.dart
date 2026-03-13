import '../../data/models/network_account.dart';
import '../../data/models/device_info.dart';
import '../../data/models/speed_test_result.dart';
import '../../data/models/repair_record.dart';

/// 网络服务 Repository 接口
abstract class NetworkRepository {
  // ==================== 网络账号管理 ====================

  /// 获取网络账号信息
  Future<NetworkAccount> getNetworkAccount();

  /// 充值
  Future<void> recharge(double amount);

  /// 获取流量使用历史
  Future<List<Map<String, dynamic>>> getTrafficHistory({
    DateTime? startDate,
    DateTime? endDate,
  });

  // ==================== 在线设备管理 ====================

  /// 获取在线设备列表
  Future<List<DeviceInfo>> getOnlineDevices();

  /// 获取设备详情
  Future<DeviceInfo> getDeviceDetail(String deviceId);

  /// 下线设备
  Future<void> offlineDevice(String deviceId);

  /// 批量下线设备
  Future<void> offlineDevices(List<String> deviceIds);

  // ==================== 网络测速 ====================

  /// 开始测速
  Future<SpeedTestResult> startSpeedTest({String? server});

  /// 获取测速历史
  Future<List<SpeedTestResult>> getSpeedTestHistory({
    int page = 1,
    int pageSize = 20,
  });

  /// 获取测速服务器列表
  Future<List<Map<String, dynamic>>> getSpeedTestServers();

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
  });

  /// 上传报修图片
  Future<String> uploadRepairImage(String filePath);

  /// 获取报修记录列表
  Future<List<RepairRecord>> getRepairRecords({
    String? status,
    int page = 1,
    int pageSize = 20,
  });

  /// 获取报修详情
  Future<RepairRecord> getRepairDetail(String repairId);

  /// 取消报修
  Future<void> cancelRepair(String repairId);

  /// 评价报修
  Future<void> rateRepair({
    required String repairId,
    required int rating,
    String? comment,
  });
}
