import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_network/core_network.dart';
import '../../data/datasources/network_service_api.dart';
import '../../data/repositories/network_repository_impl.dart';
import '../../data/repositories/mock_network_repository.dart';
import '../../domain/repositories/network_repository.dart';
import '../../data/models/network_account.dart';
import '../../data/models/device_info.dart';
import '../../data/models/speed_test_result.dart';
import '../../data/models/repair_record.dart';

// ==================== 依赖注入 ====================

/// Mock 开关 Provider（主应用可通过 ProviderScope overrides 覆盖）
final networkUseMockProvider = Provider<bool>((ref) => false);

/// ApiClient Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(config: NetworkConfig.production());
});

/// NetworkServiceApi Provider
final networkServiceApiProvider = Provider<NetworkServiceApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NetworkServiceApi(apiClient);
});

/// NetworkRepository Provider
final networkRepositoryProvider = Provider<NetworkRepository>((ref) {
  if (ref.watch(networkUseMockProvider)) return MockNetworkRepository();
  final api = ref.watch(networkServiceApiProvider);
  return NetworkRepositoryImpl(api);
});

// ==================== 网络账号管理 ====================

/// 网络账号信息 Provider
final networkAccountProvider = FutureProvider<NetworkAccount>((ref) async {
  final repository = ref.watch(networkRepositoryProvider);
  return await repository.getNetworkAccount();
});

/// 流量使用历史 Provider
final trafficHistoryProvider = FutureProvider.family<List<Map<String, dynamic>>,
    ({DateTime? startDate, DateTime? endDate})>((ref, params) async {
  final repository = ref.watch(networkRepositoryProvider);
  return await repository.getTrafficHistory(
    startDate: params.startDate,
    endDate: params.endDate,
  );
});

// ==================== 在线设备管理 ====================

/// 在线设备列表 Provider
final onlineDevicesProvider = FutureProvider<List<DeviceInfo>>((ref) async {
  final repository = ref.watch(networkRepositoryProvider);
  return await repository.getOnlineDevices();
});

/// 设备详情 Provider
final deviceDetailProvider =
    FutureProvider.family<DeviceInfo, String>((ref, deviceId) async {
  final repository = ref.watch(networkRepositoryProvider);
  return await repository.getDeviceDetail(deviceId);
});

/// 设备管理 Notifier
class DeviceManageNotifier extends StateNotifier<AsyncValue<void>> {
  final NetworkRepository _repository;

  DeviceManageNotifier(this._repository) : super(const AsyncValue.data(null));

  /// 下线设备
  Future<void> offlineDevice(String deviceId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.offlineDevice(deviceId);
    });
  }

  /// 批量下线设备
  Future<void> offlineDevices(List<String> deviceIds) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.offlineDevices(deviceIds);
    });
  }
}

/// 设备管理 Provider
final deviceManageProvider =
    StateNotifierProvider<DeviceManageNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(networkRepositoryProvider);
  return DeviceManageNotifier(repository);
});

// ==================== 网络测速 ====================

/// 测速历史 Provider
final speedTestHistoryProvider =
    FutureProvider.family<List<SpeedTestResult>, ({int page, int pageSize})>(
        (ref, params) async {
  final repository = ref.watch(networkRepositoryProvider);
  return await repository.getSpeedTestHistory(
    page: params.page,
    pageSize: params.pageSize,
  );
});

/// 测速服务器列表 Provider
final speedTestServersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(networkRepositoryProvider);
  return await repository.getSpeedTestServers();
});

/// 网络测速 Notifier
class SpeedTestNotifier extends StateNotifier<AsyncValue<SpeedTestResult?>> {
  final NetworkRepository _repository;

  SpeedTestNotifier(this._repository) : super(const AsyncValue.data(null));

  /// 开始测速
  Future<void> startSpeedTest({String? server}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _repository.startSpeedTest(server: server);
    });
  }

  /// 重置状态
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// 网络测速 Provider
final speedTestProvider =
    StateNotifierProvider<SpeedTestNotifier, AsyncValue<SpeedTestResult?>>(
        (ref) {
  final repository = ref.watch(networkRepositoryProvider);
  return SpeedTestNotifier(repository);
});

// ==================== 故障报修 ====================

/// 报修记录列表 Provider
final repairRecordsProvider = FutureProvider.family<List<RepairRecord>,
    ({String? status, int page, int pageSize})>((ref, params) async {
  final repository = ref.watch(networkRepositoryProvider);
  return await repository.getRepairRecords(
    status: params.status,
    page: params.page,
    pageSize: params.pageSize,
  );
});

/// 报修详情 Provider
final repairDetailProvider =
    FutureProvider.family<RepairRecord, String>((ref, repairId) async {
  final repository = ref.watch(networkRepositoryProvider);
  return await repository.getRepairDetail(repairId);
});

/// 故障报修 Notifier
class RepairServiceNotifier extends StateNotifier<AsyncValue<RepairRecord?>> {
  final NetworkRepository _repository;

  RepairServiceNotifier(this._repository) : super(const AsyncValue.data(null));

  /// 提交报修
  Future<void> submitRepair({
    required String title,
    required String description,
    required String type,
    required String location,
    required String contact,
    List<String>? images,
    String priority = 'normal',
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _repository.submitRepair(
        title: title,
        description: description,
        type: type,
        location: location,
        contact: contact,
        images: images,
        priority: priority,
      );
    });
  }

  /// 上传图片
  Future<String?> uploadImage(String filePath) async {
    try {
      return await _repository.uploadRepairImage(filePath);
    } catch (e) {
      return null;
    }
  }

  /// 取消报修
  Future<void> cancelRepair(String repairId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.cancelRepair(repairId);
      return null;
    });
  }

  /// 评价报修
  Future<void> rateRepair({
    required String repairId,
    required int rating,
    String? comment,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.rateRepair(
        repairId: repairId,
        rating: rating,
        comment: comment,
      );
      return null;
    });
  }

  /// 重置状态
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// 故障报修 Provider
final repairServiceProvider =
    StateNotifierProvider<RepairServiceNotifier, AsyncValue<RepairRecord?>>(
        (ref) {
  final repository = ref.watch(networkRepositoryProvider);
  return RepairServiceNotifier(repository);
});
