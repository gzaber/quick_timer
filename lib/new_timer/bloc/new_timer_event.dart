part of 'new_timer_bloc.dart';

abstract class NewTimerEvent extends Equatable {
  const NewTimerEvent();

  @override
  List<Object> get props => [];
}

class NewTimerLoadIntervalsRequested extends NewTimerEvent {}

class NewTimerLoadNamesRequested extends NewTimerEvent {}

class NewTimerCreated extends NewTimerEvent {}

class NewTimerIntervalCreated extends NewTimerEvent {
  const NewTimerIntervalCreated({required this.minutes});

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

class NewTimerIntervalSelected extends NewTimerEvent {
  const NewTimerIntervalSelected({required this.interval});

  final Interval interval;

  @override
  List<Object> get props => [interval];
}

class NewTimerNameCreated extends NewTimerEvent {
  const NewTimerNameCreated({required this.name});

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

class NewTimerNameSelected extends NewTimerEvent {
  const NewTimerNameSelected({required this.name});

  final Name name;

  @override
  List<Object> get props => [name];
}
