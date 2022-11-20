import 'package:equatable/equatable.dart';

import 'models.dart';

class Timer extends Equatable {
  const Timer({
    required this.id,
    required this.name,
    required this.interval,
  });

  final String id;
  final Name name;
  final Interval interval;

  @override
  List<Object?> get props => [id, name, interval];
}
