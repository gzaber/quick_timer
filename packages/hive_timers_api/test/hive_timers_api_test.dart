import 'package:hive/hive.dart';
import 'package:hive_timers_api/hive_timers_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:timers_api/timers_api.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box<Map<String, dynamic>> {}

void main() {
  group('HiveTimersApi', () {
    late HiveInterface mockHive;
    late Box<Map<String, dynamic>> mockBox;
    late HiveTimersApi hiveTimersApi;

    setUp(() async {
      mockHive = MockHive();
      mockBox = MockBox();

      when(() => mockHive.openBox<Map<String, dynamic>>(any()))
          .thenAnswer((_) async => mockBox);

      hiveTimersApi = await HiveTimersApi.init(mockHive);
    });

    group('init', () {
      test('works correctly', () {
        expect(
          () async => await HiveTimersApi.init(mockHive),
          returnsNormally,
        );
      });

      test('returns HiveTimersApi object', () async {
        expect(
          await HiveTimersApi.init(mockHive),
          isA<HiveTimersApi>(),
        );
      });
    });

    group('createInterval', () {
      test('creates interval', () {
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        expect(hiveTimersApi.createInterval(10), completes);
        verify(
          () => mockBox.put(isNotEmpty, {"id": isNotEmpty, "minutes": 10}),
        ).called(1);
      });
    });

    group('createName', () {
      test('creates name', () {
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        expect(hiveTimersApi.createName('name'), completes);
        verify(
          () => mockBox.put(isNotEmpty, {"id": isNotEmpty, "name": "name"}),
        ).called(1);
      });
    });

    group('createTimer', () {
      test('creates timer', () {
        final interval = Interval(minutes: 10);
        final name = Name(name: 'name');
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        expect(hiveTimersApi.createTimer(interval, name), completes);
        verify(() => mockBox.put(isNotEmpty, {
              "id": isNotEmpty,
              "interval": {
                "id": isNotEmpty,
                "minutes": 10,
              },
              "name": {
                "id": isNotEmpty,
                "name": "name",
              }
            })).called(1);
      });
    });

    group('deleteInterval', () {
      test('deletes interval', () {
        when(() => mockBox.delete(any())).thenAnswer((_) async {});

        expect(hiveTimersApi.deleteInterval('id'), completes);
        verify(() => mockBox.delete('id')).called(1);
      });
    });

    group('deleteName', () {
      test('deletes name', () {
        when(() => mockBox.delete(any())).thenAnswer((_) async {});

        expect(hiveTimersApi.deleteName('id'), completes);
        verify(() => mockBox.delete('id')).called(1);
      });
    });

    group('deleteTimer', () {
      test('deletes timer', () {
        when(() => mockBox.delete(any())).thenAnswer((_) async {});

        expect(hiveTimersApi.deleteTimer('id'), completes);
        verify(() => mockBox.delete('id')).called(1);
      });
    });

    group('readIntervals', () {
      test('reads all intervals', () async {
        final interval1 = Interval(minutes: 10);
        final interval2 = Interval(minutes: 20);
        when(() => mockBox.values.toList())
            .thenAnswer((_) => [interval1.toJson(), interval2.toJson()]);

        expect(await hiveTimersApi.readIntervals(), [interval1, interval2]);
      });
      test('returns empty list when no intervals found', () async {
        when(() => mockBox.values.toList()).thenAnswer((_) => []);

        expect(await hiveTimersApi.readIntervals(), []);
      });
    });

    group('readNames', () {
      test('read all names', () async {
        final name1 = Name(name: 'name1');
        final name2 = Name(name: 'name2');
        when(() => mockBox.values.toList())
            .thenAnswer((_) => [name1.toJson(), name2.toJson()]);

        expect(await hiveTimersApi.readNames(), [name1, name2]);
      });

      test('returns empty list when no names found', () async {
        when(() => mockBox.values.toList()).thenAnswer((_) => []);

        expect(await hiveTimersApi.readNames(), []);
      });
    });

    group('readTimers', () {
      test('read all timers', () {
        final timer1 =
            Timer(interval: Interval(minutes: 10), name: Name(name: 'name1'));
        final timer2 =
            Timer(interval: Interval(minutes: 20), name: Name(name: 'name2'));
        when(() => mockBox.values.toList())
            .thenAnswer((_) => [timer1.toJson(), timer2.toJson()]);
      });

      test('returns empty list when no timers found', () async {
        when(() => mockBox.values.toList()).thenAnswer((_) => []);

        expect(await hiveTimersApi.readTimers(), []);
      });
    });
  });
}
