import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Name', () {
    group('constructor', () {
      test('works properly', () {
        expect(() => Name(name: 'name'), returnsNormally);
      });

      test('sets id if not provided', () {
        expect(Name(name: 'name').id, isNotEmpty);
      });
    });

    test('supports value equality', () {
      expect(
        Name(id: 'id', name: 'name'),
        equals(Name(id: 'id', name: 'name')),
      );
    });

    test('props are correct', () {
      final interval = Name(id: 'id', name: 'name');
      expect(interval.props, equals(['id', 'name']));
    });
  });
}
