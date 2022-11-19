import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Interval', () {
    const duration = Duration(minutes: 10);
    group('constructor', () {
      test('works properly', () {
        expect(() => Interval(duration: duration), returnsNormally);
      });

      test('sets id if not provided', () {
        expect(Interval(duration: duration).id, isNotEmpty);
      });
    });

    test('supports value equality', () {
      expect(
        Interval(id: 'id', duration: duration),
        equals(Interval(id: 'id', duration: duration)),
      );
    });

    test('props are correct', () {
      final interval = Interval(id: 'id', duration: duration);
      expect(interval.props, equals(['id', Duration(minutes: 10)]));
    });
  });
}
