import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'interval.g.dart';

@JsonSerializable()
class Interval extends Equatable {
  Interval({
    String? id,
    required this.minutes,
  }) : id = id ?? Uuid().v4();

  final String id;
  final int minutes;

  factory Interval.fromJson(Map<String, dynamic> json) =>
      _$IntervalFromJson(json);

  Map<String, dynamic> toJson() => _$IntervalToJson(this);

  @override
  List<Object?> get props => [id, minutes];
}
