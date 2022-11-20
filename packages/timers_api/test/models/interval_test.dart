import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Interval', () {
    const id = 'id';
    const duration = Duration(minutes: 10);

    group('constructor', () {
      test('works properly', () {
        expect(() => Interval(id: id, duration: duration), returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(
        Interval(id: id, duration: duration),
        equals(Interval(id: id, duration: duration)),
      );
    });

    test('props are correct', () {
      const interval = Interval(id: id, duration: duration);
      expect(interval.props, equals(['id', Duration(minutes: 10)]));
    });
  });
}
