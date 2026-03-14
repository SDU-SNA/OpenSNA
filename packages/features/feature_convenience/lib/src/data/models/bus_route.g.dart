// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusRoute _$BusRouteFromJson(Map<String, dynamic> json) => BusRoute(
      id: json['id'] as String,
      routeName: json['routeName'] as String,
      departure: json['departure'] as String,
      destination: json['destination'] as String,
      departureTime: json['departureTime'] as String,
      arrivalTime: json['arrivalTime'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      stops:
          (json['stops'] as List<dynamic>).map((e) => e as String).toList(),
      isRunning: json['isRunning'] as bool,
      type: json['type'] as String,
    );

Map<String, dynamic> _$BusRouteToJson(BusRoute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeName': instance.routeName,
      'departure': instance.departure,
      'destination': instance.destination,
      'departureTime': instance.departureTime,
      'arrivalTime': instance.arrivalTime,
      'durationMinutes': instance.durationMinutes,
      'stops': instance.stops,
      'isRunning': instance.isRunning,
      'type': instance.type,
    };
