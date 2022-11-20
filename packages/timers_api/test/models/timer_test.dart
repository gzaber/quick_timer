import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Timer', () {
    final id = 'id';
    final name = Name(id: 'nameId', name: 'name');
    final interval = Interval(id: 'intervalId', minutes: 10);

    group('constructor', () {
      test('works properly', () {
        expect(() => Timer(name: name, interval: interval), returnsNormally);
      });

      test('sets id if not provided', () {
        expect(
          Timer(name: name, interval: interval).id,
          isNotEmpty,
        );
      });
    });

    test('supports value equality', () {
      expect(
        Timer(id: id, name: name, interval: interval),
        equals(Timer(id: id, name: name, interval: interval)),
      );
    });

    test('props are correct', () {
      expect(
          Timer(id: id, name: name, interval: interval).props,
          equals([
            'id',
            Name(id: 'nameId', name: 'name'),
            Interval(id: 'intervalId', minutes: 10),
          ]));
    });
  });
}
