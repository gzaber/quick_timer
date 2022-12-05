part of 'new_timer_bloc.dart';

enum IntervalsStatus { initial, loading, success, failure }

enum NamesStatus { initial, loading, success, failure }

enum CreationStatus { initial, loading, success, failure, unselected }

class NewTimerState extends Equatable {
  const NewTimerState({
    this.intervalsStatus = IntervalsStatus.initial,
    this.namesStatus = NamesStatus.initial,
    this.creationStatus = CreationStatus.initial,
    this.intervals = const [],
    this.names = const [],
    this.selectedInterval,
    this.selectedName,
  });

  final IntervalsStatus intervalsStatus;
  final NamesStatus namesStatus;
  final CreationStatus creationStatus;
  final List<Interval> intervals;
  final List<Name> names;
  final Interval? selectedInterval;
  final Name? selectedName;

  @override
  List<Object?> get props => [
        intervalsStatus,
        namesStatus,
        creationStatus,
        intervals,
        names,
        selectedInterval,
        selectedName
      ];

  NewTimerState copyWith({
    IntervalsStatus? intervalsStatus,
    NamesStatus? namesStatus,
    CreationStatus? creationStatus,
    List<Interval>? intervals,
    List<Name>? names,
    Interval? selectedInterval,
    Name? selectedName,
  }) {
    return NewTimerState(
      intervalsStatus: intervalsStatus ?? this.intervalsStatus,
      namesStatus: namesStatus ?? this.namesStatus,
      creationStatus: creationStatus ?? this.creationStatus,
      intervals: intervals ?? this.intervals,
      names: names ?? this.names,
      selectedInterval: selectedInterval ?? this.selectedInterval,
      selectedName: selectedName ?? this.selectedName,
    );
  }
}
