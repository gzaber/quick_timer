import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Interval', () {
    final id = 'id';
    final minutes = 10;

    group('constructor', () {
      test('works properly', () {
        expect(() => Interval(minutes: minutes), returnsNormally);
      });

      test('sets id if not provided', () {
        expect(Interval(minutes: 10).id, isNotEmpty);
      });
    });

    test('supports value equality', () {
      expect(
        Interval(id: id, minutes: minutes),
        equals(Interval(id: id, minutes: minutes)),
      );
    });

    test('props are correct', () {
      expect(
        Interval(id: id, minutes: minutes).props,
        equals(['id', 10]),
      );
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Interval.fromJson({
            "id": id,
            "minutes": minutes,
          }),
          equals(Interval(id: id, minutes: minutes)),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          Interval(id: id, minutes: minutes).toJson(),
          equals({
            "id": id,
            "minutes": minutes,
          }),
        );
      });
    });
  });
}
