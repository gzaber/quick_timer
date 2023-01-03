import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Timer', () {
    final id = 'id';
    final startupCounter = 0;
    final name = Name(id: 'nameId', name: 'name');
    final interval = Interval(id: 'intervalId', minutes: 10);

    group('constructor', () {
      test('works properly', () {
        expect(() => Timer(interval: interval, name: name), returnsNormally);
      });

      test('sets id if not provided', () {
        expect(
          Timer(interval: interval, name: name).id,
          isNotEmpty,
        );
      });

      test('sets startupCounter to 0 if not provided', () {
        expect(
          Timer(interval: interval, name: name).startupCounter,
          equals(0),
        );
      });
    });

    test('supports value equality', () {
      expect(
        Timer(id: id, interval: interval, name: name),
        equals(Timer(id: id, interval: interval, name: name)),
      );
    });

    test('props are correct', () {
      expect(
          Timer(id: id, interval: interval, name: name).props,
          equals([
            'id',
            0,
            Name(id: 'nameId', name: 'name'),
            Interval(id: 'intervalId', minutes: 10),
          ]));
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Timer.fromJson({
            "id": id,
            "startupCounter": startupCounter,
            "interval": {
              "id": "intervalId",
              "minutes": 10,
            },
            "name": {
              "id": "nameId",
              "name": "name",
            }
          }),
          equals(Timer(
              id: id,
              startupCounter: startupCounter,
              interval: interval,
              name: name)),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          Timer(id: id, interval: interval, name: name).toJson(),
          equals({
            "id": id,
            "startupCounter": startupCounter,
            "interval": {
              "id": "intervalId",
              "minutes": 10,
            },
            "name": {
              "id": "nameId",
              "name": "name",
            }
          }),
        );
      });
    });

    group('copyWith', () {
      final timer = Timer(id: id, interval: interval, name: name);

      test('return the same object if no arguments are provided', () {
        expect(
          timer.copyWith(),
          equals(timer),
        );
      });

      test('retains the old value for every null parameter', () {
        expect(
          timer.copyWith(
              id: null, startupCounter: null, interval: null, name: null),
          equals(timer),
        );
      });

      test('replaces non null parameters', () {
        final newInterval = Interval(id: 'newIntervalId', minutes: 6);
        final newName = Name(id: 'newNameId', name: 'newName');

        expect(
          timer.copyWith(
              id: 'idd',
              startupCounter: 6,
              interval: newInterval,
              name: newName),
          equals(Timer(
              id: 'idd',
              startupCounter: 6,
              interval: newInterval,
              name: newName)),
        );
      });
    });
  });
}
