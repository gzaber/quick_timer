import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:timers_api/timers_api.dart';
import 'package:timers_repository/src/timers_repository.dart';

class MockTimersApi extends Mock implements TimersApi {}

void main() {
  group('TimersRepository', () {
    late TimersApi timersApi;
    late TimersRepository timersRepository;

    setUp(() {
      timersApi = MockTimersApi();
      timersRepository = TimersRepository(timersApi: timersApi);
    });

    group('createName', () {
      test('creates name', () {
        when(() => timersApi.createName(any())).thenAnswer((_) async {});

        expect(timersRepository.createName('name'), completes);
        verify(() => timersApi.createName('name')).called(1);
      });
    });

    group('deleteName', () {
      test('deletes name', () {
        when(() => timersApi.deleteName(any())).thenAnswer((_) async {});

        expect(timersRepository.deleteName('id'), completes);
        verify(() => timersApi.deleteName('id')).called(1);
      });
    });

    group('readNames', () {
      test('returns list of names', () async {
        final name1 = Name(name: 'name1');
        final name2 = Name(name: 'name2');
        when(() => timersApi.readNames())
            .thenAnswer((_) async => [name1, name2]);

        expect(await timersRepository.readNames(), [name1, name2]);
        verify(() => timersApi.readNames()).called(1);
      });

      test('returns empty list when no names found', () async {
        when(() => timersApi.readNames()).thenAnswer((_) async => []);

        expect(await timersRepository.readNames(), []);
        verify(() => timersApi.readNames()).called(1);
      });
    });

    group('createInterval', () {
      test('creates interval', () {
        when(() => timersApi.createInterval(10)).thenAnswer((_) async => {});

        expect(timersRepository.createInterval(10), completes);
        verify(() => timersApi.createInterval(10)).called(1);
      });
    });

    group('deleteInterval', () {
      test('deletes interval', () {
        when(() => timersApi.deleteInterval('id')).thenAnswer((_) async => {});

        expect(timersRepository.deleteInterval('id'), completes);
        verify(() => timersApi.deleteInterval('id')).called(1);
      });
    });

    group('readIntervals', () {
      test('returns list of intervals', () async {
        final interval1 = Interval(minutes: 10);
        final interval2 = Interval(minutes: 20);
        when(() => timersApi.readIntervals())
            .thenAnswer((_) async => [interval1, interval2]);

        expect(await timersRepository.readIntervals(), [interval1, interval2]);
        verify(() => timersApi.readIntervals()).called(1);
      });

      test('returns empty list when no intervals found', () async {
        when(() => timersApi.readIntervals()).thenAnswer((_) async => []);

        expect(await timersRepository.readIntervals(), []);
        verify(() => timersApi.readIntervals()).called(1);
      });
    });

    group('createTimer', () {
      test('creates timer', () {
        final interval = Interval(minutes: 10);
        final name = Name(name: 'name');
        when(() => timersApi.createTimer(interval, name))
            .thenAnswer((_) async {});

        expect(timersRepository.createTimer(interval, name), completes);
        verify(() => timersApi.createTimer(interval, name)).called(1);
      });
    });

    group('deleteTimer', () {
      test('deletes timer', () {
        when(() => timersApi.deleteTimer('id')).thenAnswer((_) async {});

        expect(timersRepository.deleteTimer('id'), completes);
        verify(() => timersApi.deleteTimer('id')).called(1);
      });
    });

    group('readTimers', () {
      test('returns list of timers', () async {
        final timer1 =
            Timer(interval: Interval(minutes: 10), name: Name(name: 'name1'));
        final timer2 =
            Timer(interval: Interval(minutes: 20), name: Name(name: 'name2'));
        when(() => timersApi.readTimers())
            .thenAnswer((invocation) async => [timer1, timer2]);

        expect(await timersRepository.readTimers(), [timer1, timer2]);
        verify(() => timersApi.readTimers()).called(1);
      });

      test('returns empty list when timers not found', () async {
        when(() => timersApi.readTimers()).thenAnswer((invocation) async => []);

        expect(await timersRepository.readTimers(), []);
        verify(() => timersApi.readTimers()).called(1);
      });
    });

    group('incrementStartupCounter', () {
      test('increments startupCounter', () {
        final id = 'id';
        final interval = Interval(minutes: 10);
        final name = Name(name: 'name');
        final timer = Timer(id: id, interval: interval, name: name);

        when(() => timersApi.incrementStartupCounter(timer))
            .thenAnswer((_) async {});

        expect(timersRepository.incrementStartupCounter(timer), completes);
        verify(() => timersApi.incrementStartupCounter(timer)).called(1);
      });
    });
  });
}
