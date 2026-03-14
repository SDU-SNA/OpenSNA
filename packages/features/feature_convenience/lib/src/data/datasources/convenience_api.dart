import 'package:core_network/core_network.dart';
import '../models/classroom.dart';
import '../models/bus_route.dart';

/// 便民服务 API 数据源
class ConvenienceApi {
  final ApiClient _apiClient;

  ConvenienceApi(this._apiClient);

  // ===== 教室查询 =====

  Future<List<Classroom>> getAvailableClassrooms({
    String? building,
    String? type,
    int? minCapacity,
    DateTime? time,
  }) async {
    final response = await _apiClient.get(
      '/convenience/classrooms/available',
      queryParameters: {
        if (building != null) 'building': building,
        if (type != null) 'type': type,
        if (minCapacity != null) 'minCapacity': minCapacity,
        if (time != null) 'time': time.toIso8601String(),
      },
    );
    final data = response.data as List;
    return data
        .map((e) => Classroom.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> getBuildings() async {
    final response = await _apiClient.get('/convenience/classrooms/buildings');
    return (response.data as List).map((e) => e as String).toList();
  }

  // ===== 图书馆 =====

  Future<Map<String, dynamic>> getLibraryStatus() async {
    final response = await _apiClient.get('/convenience/library/status');
    return response.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getLibrarySeats({
    String? area,
  }) async {
    final response = await _apiClient.get(
      '/convenience/library/seats',
      queryParameters: {if (area != null) 'area': area},
    );
    return (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  // ===== 校车 =====

  Future<List<BusRoute>> getBusRoutes({String? type}) async {
    final response = await _apiClient.get(
      '/convenience/bus/routes',
      queryParameters: {if (type != null) 'type': type},
    );
    final data = response.data as List;
    return data
        .map((e) => BusRoute.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
