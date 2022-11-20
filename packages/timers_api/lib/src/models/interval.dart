import 'package:equatable/equatable.dart';

class Interval extends Equatable {
  const Interval({
    required this.id,
    required this.duration,
  });

  final String id;
  final Duration duration;

  @override
  List<Object?> get props => [id, duration];
}
