import 'package:flutter_test/flutter_test.dart';
import 'package:quick_timer/timers_overview/bloc/timers_overview_bloc.dart';
import 'package:timers_repository/timers_repository.dart';

void main() {
  group('TimersOverviewState', () {
    final timer =
        Timer(interval: Interval(minutes: 10), name: Name(name: 'name'));

    test('supports value equality', () {
      expect(
        const TimersOverviewState(),
        equals(const TimersOverviewState()),
      );
    });

    test('props are correct', () {
      expect(
        const TimersOverviewState().props,
        equals([
          TimersOverviewStatus.initial,
          TimerStatus.initial,
          [],
          [],
          null,
          0,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          const TimersOverviewState().copyWith(),
          equals(const TimersOverviewState()),
        );
      });

      test('retains the old value for every null parameter', () {
        expect(
          const TimersOverviewState().copyWith(
            status: null,
            timerStatus: null,
            timers: null,
            mostUsedTimers: null,
            countdownTimer: null,
            secondsCounter: null,
          ),
          equals(const TimersOverviewState()),
        );
      });

      test('replaces non null parameters', () {
        expect(
          const TimersOverviewState().copyWith(
            status: TimersOverviewStatus.success,
            timerStatus: TimerStatus.inProgress,
            timers: [timer],
            mostUsedTimers: [timer],
            countdownTimer: timer,
            secondsCounter: 10,
          ),
          equals(
            TimersOverviewState(
              status: TimersOverviewStatus.success,
              timerStatus: TimerStatus.inProgress,
              timers: [timer],
              mostUsedTimers: [timer],
              countdownTimer: timer,
              secondsCounter: 10,
            ),
          ),
        );
      });
    });
  });
}
