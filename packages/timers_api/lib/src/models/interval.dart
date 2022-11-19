import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Interval extends Equatable {
  Interval({
    String? id,
    required this.duration,
  }) : id = id ?? Uuid().v4();

  final String id;
  final Duration duration;

  @override
  List<Object?> get props => [id, duration];
}
