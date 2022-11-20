import 'package:test/test.dart';
import 'package:timers_api/src/models/models.dart';

void main() {
  group('Name', () {
    final id = 'id';
    final name = 'name';

    group('constructor', () {
      test('works properly', () {
        expect(() => Name(name: name), returnsNormally);
      });

      test('sets id if not provided', () {
        expect(Name(name: name).id, isNotEmpty);
      });
    });

    test('supports value equality', () {
      expect(
        Name(id: id, name: name),
        equals(Name(id: id, name: name)),
      );
    });

    test('props are correct', () {
      expect(
        Name(id: id, name: name).props,
        equals(['id', 'name']),
      );
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Name.fromJson({
            "id": id,
            "name": name,
          }),
          equals(Name(id: id, name: name)),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          Name(id: id, name: name).toJson(),
          equals({
            "id": id,
            "name": name,
          }),
        );
      });
    });
  });
}
