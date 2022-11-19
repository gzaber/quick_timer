import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

class Timer extends Equatable {
  Timer({
    required this.name,
    required this.interval,
  }) : id = Uuid().v4();

  final String id;
  final Name name;
  final Interval interval;

  @override
  List<Object?> get props => [id, name, interval];
}
