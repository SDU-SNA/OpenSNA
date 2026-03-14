import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_network/core_network.dart';
import '../../data/datasources/convenience_api.dart';
import '../../data/models/classroom.dart';
import '../../data/models/bus_route.dart';

final convenienceApiProvider = Provider<ConvenienceApi>((ref) {
  return ConvenienceApi(ApiClient());
});

// ===== 教室查询 =====

final selectedBuildingProvider = StateProvider<String?>((ref) => null);
final selectedClassroomTypeProvider = StateProvider<String?>((ref) => null);

final buildingsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(convenienceApiProvider).getBuildings();
});

final availableClassroomsProvider =
    FutureProvider.family<List<Classroom>, ({String? building, String? type})>(
        (ref, params) async {
  return ref.watch(convenienceApiProvider).getAvailableClassrooms(
        building: params.building,
        type: params.type,
      );
});

// ===== 图书馆 =====

final libraryStatusProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(convenienceApiProvider).getLibraryStatus();
});

final librarySeatsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>(
        (ref, area) async {
  return ref.watch(convenienceApiProvider).getLibrarySeats(area: area);
});

// ===== 校车 =====

final selectedBusTypeProvider = StateProvider<String?>((ref) => null);

final busRoutesProvider =
    FutureProvider.family<List<BusRoute>, String?>((ref, type) async {
  return ref.watch(convenienceApiProvider).getBusRoutes(type: type);
});
