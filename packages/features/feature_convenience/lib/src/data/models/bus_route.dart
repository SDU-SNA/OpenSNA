import 'package:json_annotation/json_annotation.dart';

part 'bus_route.g.dart';

/// 校车班次模型
@JsonSerializable()
class BusRoute {
  final String id;
  final String routeName;
  final String departure;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final int durationMinutes;
  final List<String> stops;
  final bool isRunning;
  final String type;

  const BusRoute({
    required this.id,
    required this.routeName,
    required this.departure,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.durationMinutes,
    required this.stops,
    required this.isRunning,
    required this.type,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) =>
      _$BusRouteFromJson(json);
  Map<String, dynamic> toJson() => _$BusRouteToJson(this);

  /// 距离发车的分钟数（负数表示已发车）
  int get minutesUntilDeparture {
    final now = TimeOfDay.now();
    final parts = departureTime.split(':');
    final depHour = int.parse(parts[0]);
    final depMin = int.parse(parts[1]);
    return (depHour * 60 + depMin) - (now.hour * 60 + now.minute);
  }

  bool get isDeparted => minutesUntilDeparture < 0;
  bool get isSoon => minutesUntilDeparture >= 0 && minutesUntilDeparture <= 15;

  String get typeText {
    switch (type) {
      case 'campus':
        return '校内班车';
      case 'intercampus':
        return '校区间班车';
      case 'city':
        return '城市班车';
      default:
        return '班车';
    }
  }
}
