import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Timer', () {
    final name = Name(id: 'id', name: 'name');
    final interval = Interval(id: 'id', duration: Duration(minutes: 10));
    group('constructor', () {
      test('works properly', () {
        expect(() => Timer(name: name, interval: interval), returnsNormally);
      });

      test('sets id if not provided', () {
        expect(Timer(name: name, interval: interval).id, isNotEmpty);
      });
    });

    test('supports value equality', () {
      expect(
        Timer(id: 'id', name: name, interval: interval),
        equals(Timer(id: 'id', name: name, interval: interval)),
      );
    });

    test('props are correct', () {
      final timer = Timer(id: 'id', name: name, interval: interval);
      expect(timer.props, equals(['id', name, interval]));
    });
  });
}
