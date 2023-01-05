import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_timer/new_timer/bloc/new_timer_bloc.dart';
import 'package:timers_repository/timers_repository.dart';

class MockTimersRepository extends Mock implements TimersRepository {}

class FakeInterval extends Fake implements Interval {}

class FakeName extends Fake implements Name {}

void main() {
  final intervals = [Interval(minutes: 10), Interval(minutes: 20)];
  final names = [Name(name: 'name1'), Name(name: 'name2')];

  group('NewTimerBloc', () {
    late TimersRepository timersRepository;

    setUp(() {
      timersRepository = MockTimersRepository();
    });

    setUpAll(() {
      registerFallbackValue(FakeInterval());
      registerFallbackValue(FakeName());
    });

    NewTimerBloc buildBloc() {
      return NewTimerBloc(timersRepository: timersRepository);
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          () => buildBloc(),
          returnsNormally,
        );
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const NewTimerState()),
        );
      });
    });

    group('NewTimerLoadIntervalsRequested', () {
      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with success status and intervals',
        setUp: () {
          when(() => timersRepository.readIntervals())
              .thenAnswer((_) async => intervals);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(NewTimerLoadIntervalsRequested()),
        expect: () => [
          const NewTimerState(intervalsStatus: IntervalsStatus.loading),
          NewTimerState(
              intervalsStatus: IntervalsStatus.success, intervals: intervals),
        ],
        verify: (_) {
          verify(() => timersRepository.readIntervals()).called(1);
        },
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with failure status',
        setUp: () {
          when(() => timersRepository.readIntervals()).thenThrow(Exception());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(NewTimerLoadIntervalsRequested()),
        expect: () => const [
          NewTimerState(intervalsStatus: IntervalsStatus.loading),
          NewTimerState(intervalsStatus: IntervalsStatus.failure)
        ],
        verify: (_) {
          verify(() => timersRepository.readIntervals()).called(1);
        },
      );
    });

    group('NewTimerLoadNamesRequested', () {
      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with success status and names',
        setUp: () {
          when(() => timersRepository.readNames())
              .thenAnswer((_) async => names);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(NewTimerLoadNamesRequested()),
        expect: () => [
          const NewTimerState(namesStatus: NamesStatus.loading),
          NewTimerState(namesStatus: NamesStatus.success, names: names),
        ],
        verify: (_) {
          verify(() => timersRepository.readNames()).called(1);
        },
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with failure status',
        setUp: () {
          when(() => timersRepository.readNames()).thenThrow(Exception());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(NewTimerLoadNamesRequested()),
        expect: () => const [
          NewTimerState(namesStatus: NamesStatus.loading),
          NewTimerState(namesStatus: NamesStatus.failure),
        ],
        verify: (_) {
          verify(() => timersRepository.readNames()).called(1);
        },
      );
    });

    group('NewTimerCreated', () {
      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with unselected status when interval is not selected',
        build: buildBloc,
        seed: () => NewTimerState(selectedName: names.first),
        act: (bloc) => bloc.add(NewTimerCreated()),
        expect: () => [
          NewTimerState(
              creationStatus: CreationStatus.loading,
              selectedName: names.first),
          NewTimerState(
              creationStatus: CreationStatus.unselected,
              selectedName: names.first),
          NewTimerState(
              creationStatus: CreationStatus.initial, selectedName: names.first)
        ],
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with unselected status when name is not selected',
        build: buildBloc,
        seed: () => NewTimerState(selectedInterval: intervals.first),
        act: (bloc) => bloc.add(NewTimerCreated()),
        expect: () => [
          NewTimerState(
              creationStatus: CreationStatus.loading,
              selectedInterval: intervals.first),
          NewTimerState(
              creationStatus: CreationStatus.unselected,
              selectedInterval: intervals.first),
          NewTimerState(
              creationStatus: CreationStatus.initial,
              selectedInterval: intervals.first)
        ],
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with unselected status when both name and interval are not selected',
        build: buildBloc,
        act: (bloc) => bloc.add(NewTimerCreated()),
        expect: () => const [
          NewTimerState(creationStatus: CreationStatus.loading),
          NewTimerState(creationStatus: CreationStatus.unselected),
          NewTimerState(creationStatus: CreationStatus.initial)
        ],
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with success status when timer created',
        setUp: () {
          when(() => timersRepository.createTimer(any(), any()))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => NewTimerState(
            selectedInterval: intervals.first, selectedName: names.first),
        act: (bloc) => bloc.add(NewTimerCreated()),
        expect: () => [
          NewTimerState(
              creationStatus: CreationStatus.loading,
              selectedInterval: intervals.first,
              selectedName: names.first),
          NewTimerState(
              creationStatus: CreationStatus.success,
              selectedInterval: intervals.first,
              selectedName: names.first),
        ],
        verify: (_) {
          verify(() =>
                  timersRepository.createTimer(intervals.first, names.first))
              .called(1);
        },
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with failure status',
        setUp: () {
          when(() => timersRepository.createTimer(any(), any()))
              .thenThrow(Exception());
        },
        build: buildBloc,
        seed: () => NewTimerState(
            selectedInterval: intervals.first, selectedName: names.first),
        act: (bloc) => bloc.add(NewTimerCreated()),
        expect: () => [
          NewTimerState(
              creationStatus: CreationStatus.loading,
              selectedInterval: intervals.first,
              selectedName: names.first),
          NewTimerState(
              creationStatus: CreationStatus.failure,
              selectedInterval: intervals.first,
              selectedName: names.first),
        ],
        verify: (_) {
          verify(() =>
                  timersRepository.createTimer(intervals.first, names.first))
              .called(1);
        },
      );
    });

    group('NewTimerIntervalCreated', () {
      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with success status when interval created',
        setUp: () {
          when(() => timersRepository.createInterval(any()))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const NewTimerIntervalCreated(minutes: 15)),
        expect: () => const [
          NewTimerState(intervalsStatus: IntervalsStatus.loading),
          NewTimerState(intervalsStatus: IntervalsStatus.success),
        ],
        verify: (_) {
          verify(() => timersRepository.createInterval(15)).called(1);
        },
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with failure status',
        setUp: () {
          when(() => timersRepository.createInterval(any()))
              .thenThrow(Exception());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const NewTimerIntervalCreated(minutes: 15)),
        expect: () => const [
          NewTimerState(intervalsStatus: IntervalsStatus.loading),
          NewTimerState(intervalsStatus: IntervalsStatus.failure),
        ],
        verify: (_) {
          verify(() => timersRepository.createInterval(15)).called(1);
        },
      );
    });

    group('NewTimerIntervalDeleted', () {
      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with success status when interval deleted',
        setUp: () {
          when(() => timersRepository.deleteInterval(any()))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) =>
            bloc.add(NewTimerIntervalDeleted(interval: intervals.first)),
        expect: () => const [
          NewTimerState(intervalsStatus: IntervalsStatus.loading),
          NewTimerState(intervalsStatus: IntervalsStatus.success),
        ],
        verify: (_) {
          verify(() => timersRepository.deleteInterval(intervals.first.id))
              .called(1);
        },
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with failure status',
        setUp: () {
          when(() => timersRepository.deleteInterval(any()))
              .thenThrow(Exception());
        },
        build: buildBloc,
        act: (bloc) =>
            bloc.add(NewTimerIntervalDeleted(interval: intervals.first)),
        expect: () => const [
          NewTimerState(intervalsStatus: IntervalsStatus.loading),
          NewTimerState(intervalsStatus: IntervalsStatus.failure),
        ],
        verify: (_) {
          verify(() => timersRepository.deleteInterval(intervals.first.id))
              .called(1);
        },
      );
    });

    group('NewTimerIntervalSelected', () {
      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with interval when selected',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(NewTimerIntervalSelected(interval: intervals.first)),
        expect: () => [NewTimerState(selectedInterval: intervals.first)],
      );
    });

    group('NewTimerNameCreated', () {
      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with success status when name created',
        setUp: () {
          when(() => timersRepository.createName(any()))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const NewTimerNameCreated(name: 'name')),
        expect: () => const [
          NewTimerState(namesStatus: NamesStatus.loading),
          NewTimerState(namesStatus: NamesStatus.success),
        ],
        verify: (_) {
          verify(() => timersRepository.createName('name')).called(1);
        },
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with failure status',
        setUp: () {
          when(() => timersRepository.createName(any())).thenThrow(Exception());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const NewTimerNameCreated(name: 'name')),
        expect: () => const [
          NewTimerState(namesStatus: NamesStatus.loading),
          NewTimerState(namesStatus: NamesStatus.failure),
        ],
        verify: (_) {
          verify(() => timersRepository.createName('name')).called(1);
        },
      );
    });

    group('NewTimerNameDeleted', () {
      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with success status when name deleted',
        setUp: () {
          when(() => timersRepository.deleteName(any()))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(NewTimerNameDeleted(name: names.first)),
        expect: () => const [
          NewTimerState(namesStatus: NamesStatus.loading),
          NewTimerState(namesStatus: NamesStatus.success),
        ],
        verify: (_) {
          verify(() => timersRepository.deleteName(names.first.id)).called(1);
        },
      );

      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with failure status',
        setUp: () {
          when(() => timersRepository.deleteName(any())).thenThrow(Exception());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(NewTimerNameDeleted(name: names.first)),
        expect: () => const [
          NewTimerState(namesStatus: NamesStatus.loading),
          NewTimerState(namesStatus: NamesStatus.failure),
        ],
        verify: (_) {
          verify(() => timersRepository.deleteName(names.first.id)).called(1);
        },
      );
    });

    group('NewTimerNameSelected', () {
      blocTest<NewTimerBloc, NewTimerState>(
        'emits state with name when selected',
        build: buildBloc,
        act: (bloc) => bloc.add(NewTimerNameSelected(name: names.first)),
        expect: () => [NewTimerState(selectedName: names.first)],
      );
    });
  });
}
