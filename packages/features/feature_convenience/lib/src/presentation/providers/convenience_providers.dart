import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_network/core_network.dart';
import '../../data/datasources/convenience_api.dart';
import '../../data/datasources/mock_convenience_api.dart';
import '../../data/models/classroom.dart';
import '../../data/models/bus_route.dart';

/// Mock 开关 Provider（主应用可通过 ProviderScope overrides 覆盖）
final convenienceUseMockProvider = Provider<bool>((ref) => false);

final convenienceApiProvider = Provider<ConvenienceApi>((ref) {
  return ConvenienceApi(ApiClient(config: NetworkConfig.production()));
});

final mockConvenienceApiProvider = Provider<MockConvenienceApi>((ref) {
  return MockConvenienceApi();
});

// ===== 教室查询 =====

final selectedBuildingProvider = StateProvider<String?>((ref) => null);
final selectedClassroomTypeProvider = StateProvider<String?>((ref) => null);

final buildingsProvider = FutureProvider<List<String>>((ref) async {
  if (ref.watch(convenienceUseMockProvider)) {
    return ref.watch(mockConvenienceApiProvider).getBuildings();
  }
  return ref.watch(convenienceApiProvider).getBuildings();
});

final availableClassroomsProvider =
    FutureProvider.family<List<Classroom>, ({String? building, String? type})>(
        (ref, params) async {
  if (ref.watch(convenienceUseMockProvider)) {
    return ref.watch(mockConvenienceApiProvider).getAvailableClassrooms(
          building: params.building,
          type: params.type,
        );
  }
  return ref.watch(convenienceApiProvider).getAvailableClassrooms(
        building: params.building,
        type: params.type,
      );
});

// ===== 图书馆 =====

final libraryStatusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  if (ref.watch(convenienceUseMockProvider)) {
    return ref.watch(mockConvenienceApiProvider).getLibraryStatus();
  }
  return ref.watch(convenienceApiProvider).getLibraryStatus();
});

final librarySeatsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>(
        (ref, area) async {
  if (ref.watch(convenienceUseMockProvider)) {
    return ref.watch(mockConvenienceApiProvider).getLibrarySeats(area: area);
  }
  return ref.watch(convenienceApiProvider).getLibrarySeats(area: area);
});

// ===== 校车 =====

final selectedBusTypeProvider = StateProvider<String?>((ref) => null);

final busRoutesProvider =
    FutureProvider.family<List<BusRoute>, String?>((ref, type) async {
  if (ref.watch(convenienceUseMockProvider)) {
    return ref.watch(mockConvenienceApiProvider).getBusRoutes(type: type);
  }
  return ref.watch(convenienceApiProvider).getBusRoutes(type: type);
});
