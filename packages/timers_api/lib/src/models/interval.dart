import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Interval extends Equatable {
  Interval({
    String? id,
    required this.minutes,
  }) : id = id ?? Uuid().v4();

  final String id;
  final int minutes;

  @override
  List<Object?> get props => [id, minutes];
}
