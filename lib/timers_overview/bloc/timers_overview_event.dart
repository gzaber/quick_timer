part of 'timers_overview_bloc.dart';

abstract class TimersOverviewEvent extends Equatable {
  const TimersOverviewEvent();

  @override
  List<Object?> get props => [];
}

class TimersOverviewLoadListRequested extends TimersOverviewEvent {}

class TimersOverviewTimerDeleted extends TimersOverviewEvent {}

class TimersOverviewTimerStarted extends TimersOverviewEvent {}

class TimersOverviewTimerStopped extends TimersOverviewEvent {}
