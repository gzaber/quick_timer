import 'package:flutter_test/flutter_test.dart';
import 'package:quick_timer/new_timer/new_timer.dart';
import 'package:timers_repository/timers_repository.dart';

void main() {
  group('NewTimerEvent', () {
    const minutes = 10;
    const nameStr = 'name';
    final interval = Interval(minutes: minutes);
    final name = Name(name: nameStr);

    group('NewTimerLoadIntervalsRequested', () {
      test('supports value equality', () {
        expect(
          NewTimerLoadIntervalsRequested(),
          equals(NewTimerLoadIntervalsRequested()),
        );
      });

      test('props are correct', () {
        expect(
          NewTimerLoadIntervalsRequested().props,
          equals([]),
        );
      });
    });

    group('NewTimerLoadNamesRequested', () {
      test('supports value equality', () {
        expect(
          NewTimerLoadNamesRequested(),
          equals(NewTimerLoadNamesRequested()),
        );
      });

      test('props are correct', () {
        expect(
          NewTimerLoadNamesRequested().props,
          equals([]),
        );
      });
    });

    group('NewTimerCreated', () {
      test('supports value equality', () {
        expect(
          NewTimerCreated(),
          equals(NewTimerCreated()),
        );
      });

      test('props are correct', () {
        expect(
          NewTimerCreated().props,
          equals([]),
        );
      });
    });

    group('NewTimerIntervalCreated', () {
      test('supports value equality', () {
        expect(
          const NewTimerIntervalCreated(minutes: minutes),
          equals(const NewTimerIntervalCreated(minutes: minutes)),
        );
      });

      test('props are correct', () {
        expect(
          const NewTimerIntervalCreated(minutes: minutes).props,
          equals([minutes]),
        );
      });
    });

    group('NewTimerIntervalDeleted', () {
      test('supports value equality', () {
        expect(
          NewTimerIntervalDeleted(interval: interval),
          equals(NewTimerIntervalDeleted(interval: interval)),
        );
      });

      test('props are correct', () {
        expect(
          NewTimerIntervalDeleted(interval: interval).props,
          equals([interval]),
        );
      });
    });

    group('NewTimerIntervalSelected', () {
      test('supports value equality', () {
        expect(
          NewTimerIntervalSelected(interval: interval),
          equals(NewTimerIntervalSelected(interval: interval)),
        );
      });

      test('props are correct', () {
        expect(
          NewTimerIntervalSelected(interval: interval).props,
          equals([interval]),
        );
      });
    });

    group('NewTimerNameCreated', () {
      test('supports value equality', () {
        expect(
          const NewTimerNameCreated(name: nameStr),
          equals(const NewTimerNameCreated(name: nameStr)),
        );
      });

      test('props are correct', () {
        expect(
          const NewTimerNameCreated(name: nameStr).props,
          equals([nameStr]),
        );
      });
    });

    group('NewTimerNameDeleted', () {
      test('supports value equality', () {
        expect(
          NewTimerNameDeleted(name: name),
          equals(NewTimerNameDeleted(name: name)),
        );
      });

      test('props are correct', () {
        expect(
          NewTimerNameDeleted(name: name).props,
          equals([name]),
        );
      });
    });

    group('NewTimerNameSelected', () {
      test('supports value equality', () {
        expect(
          NewTimerNameSelected(name: name),
          equals(NewTimerNameSelected(name: name)),
        );
      });

      test('props are correct', () {
        expect(
          NewTimerNameSelected(name: name).props,
          equals([name]),
        );
      });
    });
  });
}
