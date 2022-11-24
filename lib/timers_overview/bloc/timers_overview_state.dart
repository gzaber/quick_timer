part of 'timers_overview_bloc.dart';

enum TimersOverviewStatus { initial, loading, success, failure }

class TimersOverviewState extends Equatable {
  const TimersOverviewState({
    this.status = TimersOverviewStatus.initial,
    this.timers = const [],
  });

  final TimersOverviewStatus status;
  final List<Timer> timers;

  @override
  List<Object?> get props => [status, timers];

  TimersOverviewState copyWith({
    TimersOverviewStatus? status,
    List<Timer>? timers,
  }) {
    return TimersOverviewState(
      status: status ?? this.status,
      timers: timers ?? this.timers,
    );
  }
}
