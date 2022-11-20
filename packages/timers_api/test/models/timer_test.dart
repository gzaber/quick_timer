import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Timer', () {
    final id = 'id';
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
            Name(id: 'nameId', name: 'name'),
            Interval(id: 'intervalId', minutes: 10),
          ]));
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Timer.fromJson({
            "id": id,
            "interval": {
              "id": "intervalId",
              "minutes": 10,
            },
            "name": {
              "id": "nameId",
              "name": "name",
            }
          }),
          equals(Timer(id: id, interval: interval, name: name)),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          Timer(id: id, interval: interval, name: name).toJson(),
          equals({
            "id": id,
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
  });
}
