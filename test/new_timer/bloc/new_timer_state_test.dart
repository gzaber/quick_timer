import 'package:flutter_test/flutter_test.dart';
import 'package:quick_timer/new_timer/new_timer.dart';
import 'package:timers_repository/timers_repository.dart';

void main() {
  group('NewTimerState', () {
    final interval = Interval(minutes: 10);
    final name = Name(name: 'name');

    test('supports value equality', () {
      expect(const NewTimerState(), equals(const NewTimerState()));
    });

    test('props are correct', () {
      expect(
          const NewTimerState().props,
          equals([
            IntervalsStatus.initial,
            NamesStatus.initial,
            CreationStatus.initial,
            [],
            [],
            null,
            null
          ]));
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          const NewTimerState().copyWith(),
          equals(const NewTimerState()),
        );
      });

      test('retains the old value for every null parameter', () {
        expect(
          const NewTimerState().copyWith(
            intervalsStatus: null,
            namesStatus: null,
            creationStatus: null,
            intervals: null,
            names: null,
            selectedInterval: null,
            selectedName: null,
          ),
          equals(const NewTimerState()),
        );
      });

      test('replaces non null parameters', () {
        expect(
          const NewTimerState().copyWith(
            intervalsStatus: IntervalsStatus.success,
            namesStatus: NamesStatus.success,
            creationStatus: CreationStatus.success,
            intervals: [interval],
            names: [name],
            selectedInterval: interval,
            selectedName: name,
          ),
          equals(
            NewTimerState(
              intervalsStatus: IntervalsStatus.success,
              namesStatus: NamesStatus.success,
              creationStatus: CreationStatus.success,
              intervals: [interval],
              names: [name],
              selectedInterval: interval,
              selectedName: name,
            ),
          ),
        );
      });
    });
  });
}
