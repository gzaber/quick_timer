part of 'new_timer_bloc.dart';

enum NewTimerStatus { initial, loading, success, failure }

enum CreationStatus { initial, loading, success, failure, unselected }

class NewTimerState extends Equatable {
  const NewTimerState({
    this.status = NewTimerStatus.initial,
    this.creationStatus = CreationStatus.initial,
    this.intervals = const [],
    this.names = const [],
    this.selectedInterval,
    this.selectedName,
  });

  final NewTimerStatus status;
  final CreationStatus creationStatus;
  final List<Interval> intervals;
  final List<Name> names;
  final Interval? selectedInterval;
  final Name? selectedName;

  @override
  List<Object?> get props => [
        status,
        creationStatus,
        intervals,
        names,
        selectedInterval,
        selectedName
      ];

  NewTimerState copyWith({
    NewTimerStatus? status,
    CreationStatus? creationStatus,
    List<Interval>? intervals,
    List<Name>? names,
    Interval? selectedInterval,
    Name? selectedName,
  }) {
    return NewTimerState(
      status: status ?? this.status,
      creationStatus: creationStatus ?? this.creationStatus,
      intervals: intervals ?? this.intervals,
      names: names ?? this.names,
      selectedInterval: selectedInterval ?? this.selectedInterval,
      selectedName: selectedName ?? this.selectedName,
    );
  }
}
