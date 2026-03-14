import 'dart:math';
import '../models/classroom.dart';
import '../models/bus_route.dart';

/// Mock 便民服务 API（用于开发/演示）
class MockConvenienceApi {
  final _random = Random();

  Future<List<Classroom>> getAvailableClassrooms({
    String? building,
    String? type,
    int? minCapacity,
    DateTime? time,
  }) async {
    await _delay();
    final classrooms = [
      Classroom(
        id: 'cr001',
        name: 'A101',
        building: '知新楼A座',
        capacity: 120,
        type: 'lecture',
        isAvailable: true,
        nextOccupiedTime: DateTime.now().add(const Duration(hours: 4)),
      ),
      Classroom(
        id: 'cr002',
        name: 'B203',
        building: '知新楼B座',
        capacity: 60,
        type: 'seminar',
        isAvailable: true,
        nextOccupiedTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      Classroom(
        id: 'cr003',
        name: 'C305',
        building: '软件园实验楼',
        capacity: 40,
        type: 'computer',
        isAvailable: true,
      ),
      Classroom(
        id: 'cr004',
        name: 'D101',
        building: '物理楼',
        capacity: 80,
        type: 'lecture',
        isAvailable: false,
        currentCourse: '大学物理实验',
        nextOccupiedTime: DateTime.now().add(const Duration(hours: 1)),
      ),
      Classroom(
        id: 'cr005',
        name: 'A201',
        building: '知新楼A座',
        capacity: 100,
        type: 'lecture',
        isAvailable: true,
        nextOccupiedTime: DateTime.now().add(const Duration(hours: 6)),
      ),
      Classroom(
        id: 'cr006',
        name: 'E102',
        building: '外语楼',
        capacity: 50,
        type: 'seminar',
        isAvailable: false,
        currentCourse: '英语精读',
      ),
    ];

    var result = classrooms;
    if (building != null) {
      result = result.where((c) => c.building.contains(building)).toList();
    }
    if (type != null) {
      result = result.where((c) => c.type == type).toList();
    }
    if (minCapacity != null) {
      result = result.where((c) => c.capacity >= minCapacity).toList();
    }
    return result;
  }

  Future<List<String>> getBuildings() async {
    await _delay();
    return ['知新楼A座', '知新楼B座', '软件园实验楼', '物理楼', '外语楼', '图书馆'];
  }

  Future<Map<String, dynamic>> getLibraryStatus() async {
    await _delay();
    return {
      'isOpen': true,
      'openTime': '08:00',
      'closeTime': '22:00',
      'totalSeats': 1200,
      'availableSeats': 347,
      'occupancyRate': 0.71,
      'areas': [
        {'name': '一楼阅览室', 'total': 300, 'available': 85},
        {'name': '二楼自习室', 'total': 400, 'available': 120},
        {'name': '三楼研讨室', 'total': 200, 'available': 62},
        {'name': '四楼古籍阅览室', 'total': 100, 'available': 45},
        {'name': '五楼多媒体室', 'total': 200, 'available': 35},
      ],
    };
  }

  Future<List<Map<String, dynamic>>> getLibrarySeats({String? area}) async {
    await _delay();
    final areas = [
      {'area': '一楼阅览室', 'total': 300, 'available': 85, 'floor': 1},
      {'area': '二楼自习室', 'total': 400, 'available': 120, 'floor': 2},
      {'area': '三楼研讨室', 'total': 200, 'available': 62, 'floor': 3},
      {'area': '四楼古籍阅览室', 'total': 100, 'available': 45, 'floor': 4},
      {'area': '五楼多媒体室', 'total': 200, 'available': 35, 'floor': 5},
    ];
    if (area != null) {
      return areas.where((a) => a['area'] == area).toList();
    }
    return areas;
  }

  Future<List<BusRoute>> getBusRoutes({String? type}) async {
    await _delay();
    final routes = [
      BusRoute(
        id: 'bus001',
        routeName: '1路 中心↔软件园',
        departure: '中心校区',
        destination: '软件园校区',
        departureTime: '08:00',
        arrivalTime: '08:25',
        durationMinutes: 25,
        stops: ['中心校区', '趵突泉校区', '软件园校区'],
        isRunning: true,
        type: 'intercampus',
      ),
      BusRoute(
        id: 'bus002',
        routeName: '2路 中心↔兴隆山',
        departure: '中心校区',
        destination: '兴隆山校区',
        departureTime: '09:00',
        arrivalTime: '09:40',
        durationMinutes: 40,
        stops: ['中心校区', '洪家楼校区', '兴隆山校区'],
        isRunning: true,
        type: 'intercampus',
      ),
      BusRoute(
        id: 'bus003',
        routeName: '3路 中心→济南西站',
        departure: '中心校区',
        destination: '济南西站',
        departureTime: '10:00',
        arrivalTime: '10:50',
        durationMinutes: 50,
        stops: ['中心校区', '泉城广场', '济南西站'],
        isRunning: true,
        type: 'city',
      ),
      BusRoute(
        id: 'bus004',
        routeName: '4路 软件园↔中心',
        departure: '软件园校区',
        destination: '中心校区',
        departureTime: '17:30',
        arrivalTime: '17:55',
        durationMinutes: 25,
        stops: ['软件园校区', '趵突泉校区', '中心校区'],
        isRunning: true,
        type: 'intercampus',
      ),
    ];

    if (type != null) {
      return routes.where((r) => r.type == type).toList();
    }
    return routes;
  }

  Future<void> _delay() =>
      Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
}
