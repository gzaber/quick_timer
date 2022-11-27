part of 'new_timer_bloc.dart';

abstract class NewTimerEvent extends Equatable {
  const NewTimerEvent();

  @override
  List<Object> get props => [];
}

class NewTimerLoadDataRequested extends NewTimerEvent {}

class NewTimerIntervalAdded extends NewTimerEvent {
  const NewTimerIntervalAdded({required this.minutes});

  final int minutes;

  @override
  List<Object> get props => [minutes];
}

class NewTimerIntervalDeleted extends NewTimerEvent {
  const NewTimerIntervalDeleted({required this.interval});

  final Interval interval;

  @override
  List<Object> get props => [interval];
}

class NewTimerNameAdded extends NewTimerEvent {
  const NewTimerNameAdded({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class NewTimerNameDeleted extends NewTimerEvent {
  const NewTimerNameDeleted({required this.name});

  final Name name;

  @override
  List<Object> get props => [name];
}
