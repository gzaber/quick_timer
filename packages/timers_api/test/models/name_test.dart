import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Name', () {
    const id = 'id';
    const name = 'name';

    group('constructor', () {
      test('works properly', () {
        expect(() => Name(id: id, name: name), returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(
        Name(id: id, name: name),
        equals(Name(id: id, name: name)),
      );
    });

    test('props are correct', () {
      const interval = Name(id: id, name: name);
      expect(interval.props, equals(['id', 'name']));
    });
  });
}
