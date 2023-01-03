// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timer _$TimerFromJson(Map<String, dynamic> json) => Timer(
      id: json['id'] as String?,
      startupCounter: json['startupCounter'] as int? ?? 0,
      interval: Interval.fromJson(json['interval'] as Map<String, dynamic>),
      name: Name.fromJson(json['name'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimerToJson(Timer instance) => <String, dynamic>{
      'id': instance.id,
      'startupCounter': instance.startupCounter,
      'interval': instance.interval.toJson(),
      'name': instance.name.toJson(),
    };
