import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_timer/timers_overview/counter.dart';
import 'package:quick_timer/timers_overview/timers_overview.dart';
import 'package:timers_repository/timers_repository.dart';

class MockTimersRepository extends Mock implements TimersRepository {}

class MockCounter extends Mock implements Counter {}

class FakeTimer extends Fake implements Timer {}

void main() {
  final timer1 =
      Timer(interval: Interval(minutes: 1), name: Name(name: 'name1'));
  final timer2 =
      Timer(interval: Interval(minutes: 15), name: Name(name: 'name2'));
  final timer3 =
      Timer(interval: Interval(minutes: 5), name: Name(name: 'name3'));
  final timer4 = Timer(
      interval: Interval(minutes: 45),
      name: Name(name: 'name4'),
      startupCounter: 6);
  final mockTimers = [timer1, timer2, timer3, timer4];

  group('TimersOverviewBloc', () {
    late TimersRepository timersRepository;
    late Counter counter;

    setUp(() {
      timersRepository = MockTimersRepository();
      counter = MockCounter();
    });

    setUpAll(() {
      registerFallbackValue(FakeTimer());
    });

    TimersOverviewBloc buildBloc() {
      return TimersOverviewBloc(
          timersRepository: timersRepository, counter: counter);
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
          equals(const TimersOverviewState()),
        );
      });
    });

    group('TimersOverviewLoadTimersRequested', () {
      blocTest<TimersOverviewBloc, TimersOverviewState>(
        'emits state with success status and timers',
        setUp: () {
          when(() => timersRepository.readTimers())
              .thenAnswer((_) async => mockTimers);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(TimersOverviewLoadTimersRequested()),
        expect: () => [
          const TimersOverviewState(status: TimersOverviewStatus.loading),
          TimersOverviewState(
              status: TimersOverviewStatus.success,
              timers: [timer1, timer2, timer3],
              mostUsedTimers: [timer4]),
        ],
        verify: (_) {
          verify(() => timersRepository.readTimers()).called(1);
        },
      );

      blocTest<TimersOverviewBloc, TimersOverviewState>(
        'emits state with failure status',
        setUp: () {
          when(() => timersRepository.readTimers()).thenThrow(Exception());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(TimersOverviewLoadTimersRequested()),
        expect: () => const [
          TimersOverviewState(status: TimersOverviewStatus.loading),
          TimersOverviewState(status: TimersOverviewStatus.failure)
        ],
        verify: (_) {
          verify(() => timersRepository.readTimers()).called(1);
        },
      );
    });

    group('TimersOverviewTimerDeleted', () {
      blocTest<TimersOverviewBloc, TimersOverviewState>(
        'emits state with success status when timer deleted',
        setUp: () {
          when(() => timersRepository.deleteTimer(any()))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(TimersOverviewTimerDeleted(timer: timer1)),
        expect: () => const [
          TimersOverviewState(status: TimersOverviewStatus.loading),
          TimersOverviewState(status: TimersOverviewStatus.success),
        ],
        verify: (_) {
          verify(() => timersRepository.deleteTimer(timer1.id)).called(1);
        },
      );

      blocTest<TimersOverviewBloc, TimersOverviewState>(
        'emits state with failure status',
        setUp: () {
          when(() => timersRepository.deleteTimer(any()))
              .thenThrow(Exception());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(TimersOverviewTimerDeleted(timer: timer1)),
        expect: () => const [
          TimersOverviewState(status: TimersOverviewStatus.loading),
          TimersOverviewState(status: TimersOverviewStatus.failure),
        ],
        verify: (_) {
          verify(() => timersRepository.deleteTimer(timer1.id)).called(1);
        },
      );
    });

    group('TimersOverviewTimerStarted', () {
      blocTest<TimersOverviewBloc, TimersOverviewState>(
        'emits state with inProgress status and updated seconds counter '
        'after timer started',
        setUp: () {
          when(() => counter.countdown(seconds: 60)).thenAnswer((_) =>
              Stream<int>.fromIterable(
                  List.generate(60, (index) => index + 1).reversed));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(TimersOverviewTimerStarted(timer: timer1)),
        expect: () => [
          ...List.generate(
              timer1.interval.minutes * 60,
              (index) => TimersOverviewState(
                  timerStatus: TimerStatus.inProgress,
                  countdownTimer: timer1,
                  secondsCounter: index + 1)).reversed.toList(),
        ],
      );

      blocTest<TimersOverviewBloc, TimersOverviewState>(
        'emits state with completed then initial status and initial seconds counter '
        'when timer finished',
        setUp: () {
          when(() => timersRepository.incrementStartupCounter(any()))
              .thenAnswer((_) async {});
          when(() => counter.countdown(seconds: 60)).thenAnswer((_) =>
              Stream<int>.fromIterable(
                  List.generate(60 + 1, (index) => index).reversed));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(TimersOverviewTimerStarted(timer: timer1)),
        expect: () => [
          ...List.generate(
              timer1.interval.minutes * 60,
              (index) => TimersOverviewState(
                  timerStatus: TimerStatus.inProgress,
                  countdownTimer: timer1,
                  secondsCounter: index + 1)).reversed.toList(),
          TimersOverviewState(
              timerStatus: TimerStatus.completed,
              countdownTimer: timer1,
              secondsCounter: 1),
          TimersOverviewState(
              timerStatus: TimerStatus.initial,
              countdownTimer: timer1,
              secondsCounter: 0),
        ],
      );

      blocTest<TimersOverviewBloc, TimersOverviewState>(
        'emits state with failure status when exception occured during '
        'incrementing timer startup field',
        setUp: () {
          when(() => timersRepository.incrementStartupCounter(any()))
              .thenThrow(Exception());
          when(() => counter.countdown(seconds: 60)).thenAnswer((_) =>
              Stream<int>.fromIterable(
                  List.generate(60 + 1, (index) => index).reversed));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(TimersOverviewTimerStarted(timer: timer1)),
        expect: () => [
          ...List.generate(
              timer1.interval.minutes * 60,
              (index) => TimersOverviewState(
                  timerStatus: TimerStatus.inProgress,
                  countdownTimer: timer1,
                  secondsCounter: index + 1)).reversed.toList(),
          TimersOverviewState(
              timerStatus: TimerStatus.completed,
              countdownTimer: timer1,
              secondsCounter: 1),
          TimersOverviewState(
              timerStatus: TimerStatus.initial,
              countdownTimer: timer1,
              secondsCounter: 0),
          TimersOverviewState(
              status: TimersOverviewStatus.failure,
              timerStatus: TimerStatus.initial,
              countdownTimer: timer1,
              secondsCounter: 0),
        ],
      );
    });

    group('TimersOverviewTimerReset', () {
      blocTest<TimersOverviewBloc, TimersOverviewState>(
        'emits state with initial status and initial seconds counter',
        build: buildBloc,
        seed: () => TimersOverviewState(
            timerStatus: TimerStatus.inProgress,
            countdownTimer: timer1,
            secondsCounter: 30),
        act: (bloc) => bloc.add(TimersOverviewTimerReset()),
        expect: () => [
          TimersOverviewState(
              timerStatus: TimerStatus.initial,
              countdownTimer: timer1,
              secondsCounter: 0)
        ],
      );
    });
  });
}
