import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Timer', () {
    const id = 'id';
    const name = Name(id: 'nameId', name: 'name');
    const interval =
        Interval(id: 'intervalId', duration: Duration(minutes: 10));
    group('constructor', () {
      test('works properly', () {
        expect(() => Timer(id: id, name: name, interval: interval),
            returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(
        Timer(id: id, name: name, interval: interval),
        equals(Timer(id: id, name: name, interval: interval)),
      );
    });

    test('props are correct', () {
      const timer = Timer(id: id, name: name, interval: interval);
      expect(
          timer.props,
          equals([
            'id',
            Name(id: 'nameId', name: 'name'),
            Interval(id: 'intervalId', duration: Duration(minutes: 10)),
          ]));
    });
  });
}
