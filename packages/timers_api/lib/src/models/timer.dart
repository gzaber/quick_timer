import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

part 'timer.g.dart';

@JsonSerializable(explicitToJson: true)
class Timer extends Equatable {
  Timer({
    String? id,
    this.startupCounter = 0,
    required this.interval,
    required this.name,
  }) : id = id ?? Uuid().v4();

  final String id;
  final int startupCounter;
  final Interval interval;
  final Name name;

  factory Timer.fromJson(Map<String, dynamic> json) => _$TimerFromJson(json);

  Map<String, dynamic> toJson() => _$TimerToJson(this);

  @override
  List<Object?> get props => [id, startupCounter, name, interval];

  Timer copyWith({
    String? id,
    int? startupCounter,
    Interval? interval,
    Name? name,
  }) {
    return Timer(
      id: id ?? this.id,
      startupCounter: startupCounter ?? this.startupCounter,
      interval: interval ?? this.interval,
      name: name ?? this.name,
    );
  }
}
