import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';

part 'timer.g.dart';

@JsonSerializable(explicitToJson: true)
class Timer extends Equatable {
  Timer({
    String? id,
    required this.interval,
    required this.name,
  }) : id = id ?? Uuid().v4();

  final String id;
  final Interval interval;
  final Name name;

  factory Timer.fromJson(Map<String, dynamic> json) => _$TimerFromJson(json);

  Map<String, dynamic> toJson() => _$TimerToJson(this);

  @override
  List<Object?> get props => [id, name, interval];
}
