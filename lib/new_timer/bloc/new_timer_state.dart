part of 'new_timer_bloc.dart';

enum NewTimerStatus { initial, loading, success, failure }

class NewTimerState extends Equatable {
  const NewTimerState({
    this.status = NewTimerStatus.initial,
    this.intervals = const [],
    this.names = const [],
  });

  final NewTimerStatus status;
  final List<Interval> intervals;
  final List<Name> names;

  @override
  List<Object> get props => [status, intervals, names];

  NewTimerState copyWith({
    NewTimerStatus? status,
    List<Interval>? intervals,
    List<Name>? names,
  }) {
    return NewTimerState(
      status: status ?? this.status,
      intervals: intervals ?? this.intervals,
      names: names ?? this.names,
    );
  }
}
