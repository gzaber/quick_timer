part of 'timers_overview_bloc.dart';

@immutable
abstract class TimersOverviewEvent {}

class TimersOverviewLoadListRequested extends TimersOverviewEvent {}

class TimersOverviewTimerDeleted extends TimersOverviewEvent {}

class TimersOverviewTimerStarted extends TimersOverviewEvent {}

class TimersOverviewTimerStopped extends TimersOverviewEvent {}
