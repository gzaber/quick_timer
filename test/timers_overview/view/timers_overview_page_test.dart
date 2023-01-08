import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:quick_timer/timers_overview/timers_overview.dart';
import 'package:timers_repository/timers_repository.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp({
    required TimersOverviewBloc timersOverviewBloc,
    MockNavigator? navigator,
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: timersOverviewBloc,
        child: MaterialApp(
          home: navigator == null
              ? const TimersOverviewView()
              : MockNavigatorProvider(
                  navigator: navigator,
                  child: const TimersOverviewView(),
                ),
        ),
      ),
    );
  }
}

class MockTimersRepository extends Mock implements TimersRepository {}

class MockTimersOverviewBloc
    extends MockBloc<TimersOverviewEvent, TimersOverviewState>
    implements TimersOverviewBloc {}

class MockAudioPlayer extends Mock implements AudioPlayer {}

class MockSource extends Mock implements Source {}

void main() {
  final timer1 =
      Timer(interval: Interval(minutes: 10), name: Name(name: 'name1'));
  final timer2 =
      Timer(interval: Interval(minutes: 15), name: Name(name: 'name2'));
  final timer3 =
      Timer(interval: Interval(minutes: 5), name: Name(name: 'name3'));
  final timer4 = Timer(
    interval: Interval(minutes: 45),
    name: Name(name: 'name4'),
    startupCounter: 3,
  );
  final timer5 = Timer(
    interval: Interval(minutes: 50),
    name: Name(name: 'name5'),
    startupCounter: 6,
  );
  final timer6 = Timer(
    interval: Interval(minutes: 60),
    name: Name(name: 'name6'),
    startupCounter: 9,
  );

  final mockTimers = [timer1, timer2, timer3, timer4, timer5, timer6];

  group('TimersOverviewPage', () {
    late TimersRepository timersRepository;

    setUp(() {
      timersRepository = MockTimersRepository();
      when(() => timersRepository.readTimers())
          .thenAnswer((_) async => mockTimers);
    });

    testWidgets('renders TimersOverviewView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: timersRepository,
          child: const MaterialApp(
            home: TimersOverviewPage(),
          ),
        ),
      );

      expect(find.byType(TimersOverviewView), findsOneWidget);
      verify(() => timersRepository.readTimers()).called(1);
    });
  });

  group('TimersOverviewView', () {
    late TimersOverviewBloc timersOverviewBloc;

    setUp(() {
      timersOverviewBloc = MockTimersOverviewBloc();
    });

    setUpAll(() {
      registerFallbackValue(MockSource());
    });

    testWidgets('renders AppBar with title', (tester) async {
      when(() => timersOverviewBloc.state)
          .thenReturn(const TimersOverviewState());

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);

      expect(
          find.descendant(
              of: find.byType(AppBar), matching: find.text('QuickTimer')),
          findsOneWidget);
    });

    testWidgets('renders 2 headers', (tester) async {
      when(() => timersOverviewBloc.state)
          .thenReturn(const TimersOverviewState());

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);

      expect(find.text('Most used timers'), findsOneWidget);
      expect(find.text('Other timers'), findsOneWidget);
    });

    testWidgets('renders FloatingActionButton with add icon', (tester) async {
      when(() => timersOverviewBloc.state)
          .thenReturn(const TimersOverviewState());

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);

      expect(
          find.descendant(
              of: find.byType(FloatingActionButton),
              matching: find.byIcon(Icons.add)),
          findsOneWidget);
    });

    testWidgets('renders 2 CircularProgressIndicators when loading data',
        (tester) async {
      when(() => timersOverviewBloc.state).thenReturn(
          const TimersOverviewState(status: TimersOverviewStatus.loading));

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);

      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });

    testWidgets('renders info that there are no timers yet', (tester) async {
      when(() => timersOverviewBloc.state).thenReturn(
          const TimersOverviewState(status: TimersOverviewStatus.success));

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);

      expect(find.text('No timers yet'), findsNWidgets(2));
    });

    testWidgets('renders 2 most used timers', (tester) async {
      when(() => timersOverviewBloc.state).thenReturn(
        TimersOverviewState(
          status: TimersOverviewStatus.success,
          timers: [timer1, timer2, timer3],
          mostUsedTimers: [timer4, timer5],
        ),
      );

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);

      expect(find.text(timer4.name.name), findsNWidgets(1));
      expect(find.text('${timer4.interval.minutes} min'), findsNWidgets(1));
      expect(find.text(timer5.name.name), findsNWidgets(1));
      expect(find.text('${timer5.interval.minutes} min'), findsNWidgets(1));
    });

    testWidgets('renders 3 most used timers', (tester) async {
      when(() => timersOverviewBloc.state).thenReturn(
        TimersOverviewState(
          status: TimersOverviewStatus.success,
          timers: [timer1, timer2, timer3],
          mostUsedTimers: [timer4, timer5, timer6],
        ),
      );

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);

      expect(find.text(timer4.name.name), findsNWidgets(1));
      expect(find.text('${timer4.interval.minutes} min'), findsNWidgets(1));
      expect(find.text(timer5.name.name), findsNWidgets(1));
      expect(find.text('${timer5.interval.minutes} min'), findsNWidgets(1));
      expect(find.text(timer6.name.name), findsNWidgets(1));
      expect(find.text('${timer6.interval.minutes} min'), findsNWidgets(1));
    });

    testWidgets('renders 3 other timers', (tester) async {
      when(() => timersOverviewBloc.state).thenReturn(
        TimersOverviewState(
          status: TimersOverviewStatus.success,
          timers: [timer1, timer2, timer3],
          mostUsedTimers: [timer4, timer5],
        ),
      );

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);

      expect(find.text(timer1.name.name), findsNWidgets(1));
      expect(find.text('${timer1.interval.minutes} min'), findsNWidgets(1));
      expect(find.text(timer2.name.name), findsNWidgets(1));
      expect(find.text('${timer2.interval.minutes} min'), findsNWidgets(1));
      expect(find.text(timer3.name.name), findsNWidgets(1));
      expect(find.text('${timer3.interval.minutes} min'), findsNWidgets(1));
    });

    testWidgets('shows SnackBar with info when failure occurs', (tester) async {
      when(() => timersOverviewBloc.state)
          .thenReturn(const TimersOverviewState());
      whenListen(
          timersOverviewBloc,
          Stream.fromIterable(
            const [
              TimersOverviewState(status: TimersOverviewStatus.loading),
              TimersOverviewState(status: TimersOverviewStatus.failure),
            ],
          ));

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);
      await tester.pump();

      expect(
          find.descendant(
              of: find.byType(SnackBar),
              matching: find.text('Something went wrong')),
          findsOneWidget);
    });

    testWidgets('timer starts when it is tapped', (tester) async {
      when(() => timersOverviewBloc.state).thenReturn(
        TimersOverviewState(
          status: TimersOverviewStatus.success,
          timers: [timer1],
        ),
      );

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);
      await tester.tap(find.text(timer1.name.name));

      verify(
        () => timersOverviewBloc.add(TimersOverviewTimerStarted(timer: timer1)),
      ).called(1);
    });

    testWidgets('timer resets when pause icon is tapped', (tester) async {
      when(() => timersOverviewBloc.state).thenReturn(
        TimersOverviewState(
          status: TimersOverviewStatus.success,
          timerStatus: TimerStatus.inProgress,
          countdownTimer: timer1,
          timers: [timer1],
        ),
      );

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);
      await tester.tap(find.byIcon(Icons.pause));

      verify(
        () => timersOverviewBloc.add(TimersOverviewTimerReset()),
      ).called(1);
    });

    testWidgets('plays audio file when timer is completed', (tester) async {
      late AudioPlayer audioPlayer = MockAudioPlayer();
      GetIt.I.registerLazySingleton<AudioPlayer>(() => audioPlayer);
      when(() => audioPlayer.play(any())).thenAnswer((_) async {});

      when(() => timersOverviewBloc.state)
          .thenReturn(const TimersOverviewState());
      whenListen(
          timersOverviewBloc,
          Stream.fromIterable(
            const [
              TimersOverviewState(timerStatus: TimerStatus.inProgress),
              TimersOverviewState(timerStatus: TimerStatus.completed),
            ],
          ));

      await tester.pumpApp(timersOverviewBloc: timersOverviewBloc);

      verify(() => audioPlayer.play(any())).called(1);
    });

    testWidgets('navigates to DeleteItemDialog when timer is long pressed',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<bool>(any(that: isRoute<bool>())))
          .thenAnswer((_) async => null);
      when(() => timersOverviewBloc.state).thenReturn(
        TimersOverviewState(
          status: TimersOverviewStatus.success,
          timers: [timer1],
        ),
      );

      await tester.pumpApp(
          timersOverviewBloc: timersOverviewBloc, navigator: navigator);
      await tester.longPress(find.text(timer1.name.name));

      verify(() => navigator.push<bool>(any(that: isRoute<bool>()))).called(1);
    });

    testWidgets('deletes timer when true is returned from dialog',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<bool>(any(that: isRoute<bool>())))
          .thenAnswer((_) async => true);
      when(() => timersOverviewBloc.state).thenReturn(
        TimersOverviewState(
          status: TimersOverviewStatus.success,
          timers: [timer1],
        ),
      );

      await tester.pumpApp(
          timersOverviewBloc: timersOverviewBloc, navigator: navigator);
      await tester.longPress(find.text(timer1.name.name));
      await tester.pumpAndSettle();

      verify(() =>
              timersOverviewBloc.add(TimersOverviewTimerDeleted(timer: timer1)))
          .called(1);
      verify(() => timersOverviewBloc.add(TimersOverviewLoadTimersRequested()))
          .called(1);
    });

    testWidgets('navigates to NewTimerPage when FloatingActionButton is tapped',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});
      when(() => timersOverviewBloc.state)
          .thenReturn(const TimersOverviewState());

      await tester.pumpApp(
          timersOverviewBloc: timersOverviewBloc, navigator: navigator);
      await tester.tap(find.byType(FloatingActionButton));

      verify(() => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/new_timer'))))).called(1);
    });

    testWidgets('reads timers when pops from NewTimerPage', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<void>(
              any(that: isRoute<void>(whereName: equals('/new_timer')))))
          .thenAnswer((_) async {});
      when(() => timersOverviewBloc.state)
          .thenReturn(const TimersOverviewState());

      await tester.pumpApp(
          timersOverviewBloc: timersOverviewBloc, navigator: navigator);
      await tester.tap(find.byType(FloatingActionButton));

      verify(() => timersOverviewBloc.add(TimersOverviewLoadTimersRequested()))
          .called(1);
    });
  });
}
