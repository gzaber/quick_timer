import 'package:flutter_test/flutter_test.dart';
import 'package:quick_timer/timers_overview/timers_overview.dart';
import 'package:timers_repository/timers_repository.dart';

void main() {
  group('TimersOverviewEvent', () {
    final timer =
        Timer(interval: Interval(minutes: 10), name: Name(name: 'name'));

    group('TimersOverviewLoadTimersRequested', () {
      test('supports value equality', () {
        expect(
          TimersOverviewLoadTimersRequested(),
          equals(TimersOverviewLoadTimersRequested()),
        );
      });

      test('props are correct', () {
        expect(
          TimersOverviewLoadTimersRequested().props,
          equals([]),
        );
      });
    });

    group('TimersOverviewTimerDeleted', () {
      test('supports value equality', () {
        expect(
          TimersOverviewTimerDeleted(timer: timer),
          equals(TimersOverviewTimerDeleted(timer: timer)),
        );
      });

      test('props are correct', () {
        expect(
          TimersOverviewTimerDeleted(timer: timer).props,
          equals([timer]),
        );
      });
    });

    group('TimersOverviewTimerStarted', () {
      test('supports value equality', () {
        expect(
          TimersOverviewTimerStarted(timer: timer),
          equals(TimersOverviewTimerStarted(timer: timer)),
        );
      });

      test('props are correct', () {
        expect(
          TimersOverviewTimerStarted(timer: timer).props,
          equals([timer]),
        );
      });
    });

    group('TimersOverviewTimerReset', () {
      test('supports value equality', () {
        expect(
          TimersOverviewTimerReset(),
          equals(TimersOverviewTimerReset()),
        );
      });

      test('props are correct', () {
        expect(
          TimersOverviewTimerReset().props,
          equals([]),
        );
      });
    });

    group('TimersOverviewTimerCounted', () {
      test('supports value equality', () {
        expect(
          const TimersOverviewTimerCounted(60),
          equals(const TimersOverviewTimerCounted(60)),
        );
      });

      test('props are correct', () {
        expect(
          const TimersOverviewTimerCounted(60).props,
          equals([60]),
        );
      });
    });
  });
}
