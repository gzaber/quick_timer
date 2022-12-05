part of 'timers_overview_bloc.dart';

abstract class TimersOverviewEvent extends Equatable {
  const TimersOverviewEvent();

  @override
  List<Object> get props => [];
}

class TimersOverviewLoadTimersRequested extends TimersOverviewEvent {}

class TimersOverviewTimerDeleted extends TimersOverviewEvent {
  const TimersOverviewTimerDeleted({required this.timer});

  final Timer timer;

  @override
  List<Object> get props => [timer];
}

// class TimersOverviewTimerStarted extends TimersOverviewEvent {}

// class TimersOverviewTimerStopped extends TimersOverviewEvent {}
