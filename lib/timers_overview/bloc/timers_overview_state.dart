part of 'timers_overview_bloc.dart';

enum TimersOverviewStatus { initial, loading, success, failure }

enum TimerStatus { initial, inProgress, completed }

class TimersOverviewState extends Equatable {
  const TimersOverviewState({
    this.status = TimersOverviewStatus.initial,
    this.timerStatus = TimerStatus.initial,
    this.timers = const [],
    this.mostUsedTimers = const [],
    this.countdownTimer,
    this.secondsCounter = 0,
  });

  final TimersOverviewStatus status;
  final TimerStatus timerStatus;
  final List<Timer> timers;
  final List<Timer> mostUsedTimers;
  final Timer? countdownTimer;
  final int secondsCounter;

  @override
  List<Object?> get props =>
      [status, timerStatus, timers, countdownTimer, secondsCounter];

  TimersOverviewState copyWith({
    TimersOverviewStatus? status,
    TimerStatus? timerStatus,
    List<Timer>? timers,
    List<Timer>? mostUsedTimers,
    Timer? countdownTimer,
    int? secondsCounter,
  }) {
    return TimersOverviewState(
      status: status ?? this.status,
      timerStatus: timerStatus ?? this.timerStatus,
      timers: timers ?? this.timers,
      mostUsedTimers: mostUsedTimers ?? this.mostUsedTimers,
      countdownTimer: countdownTimer ?? this.countdownTimer,
      secondsCounter: secondsCounter ?? this.secondsCounter,
    );
  }
}
