import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Interval extends Equatable {
  Interval({required this.duration}) : id = Uuid().v4();

  final String id;
  final Duration duration;

  @override
  List<Object?> get props => [id, duration];
}
