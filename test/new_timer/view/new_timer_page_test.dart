import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:quick_timer/new_timer/new_timer.dart';
import 'package:timers_repository/timers_repository.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp(
      {required NewTimerBloc newTimerBloc, MockNavigator? navigator}) {
    return pumpWidget(
      BlocProvider.value(
        value: newTimerBloc,
        child: MaterialApp(
          home: navigator == null
              ? const NewTimerView()
              : MockNavigatorProvider(
                  navigator: navigator,
                  child: const NewTimerView(),
                ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    );
  }
}

class MockTimersRepository extends Mock implements TimersRepository {}

class MockNewTimerBloc extends MockBloc<NewTimerEvent, NewTimerState>
    implements NewTimerBloc {}

class MockRoute<int> extends Fake implements Route<int> {}

void main() {
  final interval1 = Interval(minutes: 10);
  final interval2 = Interval(minutes: 15);
  final interval3 = Interval(minutes: 20);
  final intervals = [interval1, interval2, interval3];
  final name1 = Name(name: 'name1');
  final name2 = Name(name: 'name2');
  final name3 = Name(name: 'name3');
  final names = [name1, name2, name3];

  group('NewTimerPage', () {
    late TimersRepository timersRepository;

    setUp(() {
      timersRepository = MockTimersRepository();
      when(() => timersRepository.readIntervals())
          .thenAnswer((_) async => intervals);
      when(() => timersRepository.readNames()).thenAnswer((_) async => names);
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: timersRepository,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      NewTimerPage.route(),
                    );
                  },
                ),
              ),
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(NewTimerPage), findsOneWidget);
    });

    testWidgets('renders NewTimerView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: timersRepository,
          child: const MaterialApp(
            home: NewTimerPage(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        ),
      );

      expect(find.byType(NewTimerView), findsOneWidget);
      verify(() => timersRepository.readIntervals()).called(1);
      verify(() => timersRepository.readNames()).called(1);
    });
  });

  group('NewTimerView', () {
    final l10n = AppLocalizationsEn();
    late NewTimerBloc newTimerBloc;

    setUp(() {
      newTimerBloc = MockNewTimerBloc();
    });

    setUpAll(() {
      registerFallbackValue(MockRoute<int>());
    });

    testWidgets('renders AppBar with title and back button', (tester) async {
      when(() => newTimerBloc.state).thenReturn(const NewTimerState());

      await tester.pumpApp(newTimerBloc: newTimerBloc);

      expect(
        find.descendant(
            of: find.byType(AppBar),
            matching: find.text(l10n.newTimerAppBarTitle)),
        findsOneWidget,
      );
      expect(
        find.descendant(
            of: find.byType(AppBar),
            matching: find.byIcon(Icons.arrow_back_ios)),
        findsOneWidget,
      );
    });

    testWidgets('renders 2 headers', (tester) async {
      when(() => newTimerBloc.state).thenReturn(const NewTimerState());

      await tester.pumpApp(newTimerBloc: newTimerBloc);

      expect(find.text(l10n.newTimerIntervalsHeader), findsOneWidget);
      expect(find.text(l10n.newTimerNamesHeader), findsOneWidget);
    });

    testWidgets('renders FloatingActionButton with text', (tester) async {
      when(() => newTimerBloc.state).thenReturn(const NewTimerState());

      await tester.pumpApp(newTimerBloc: newTimerBloc);

      expect(
        find.descendant(
            of: find.byType(FloatingActionButton),
            matching: find.text(l10n.newTimerAddTimerButtonText)),
        findsOneWidget,
      );
    });

    testWidgets('renders CircularProgressIndicator when loading intervals',
        (tester) async {
      when(() => newTimerBloc.state).thenReturn(
          const NewTimerState(intervalsStatus: IntervalsStatus.loading));

      await tester.pumpApp(newTimerBloc: newTimerBloc);

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    });

    testWidgets('renders CircularProgressIndicator when loading names',
        (tester) async {
      when(() => newTimerBloc.state)
          .thenReturn(const NewTimerState(namesStatus: NamesStatus.loading));

      await tester.pumpApp(newTimerBloc: newTimerBloc);

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    });

    testWidgets('renders 2 intervals', (tester) async {
      when(() => newTimerBloc.state).thenReturn(
        NewTimerState(
          intervalsStatus: IntervalsStatus.success,
          intervals: [interval1, interval2],
        ),
      );

      await tester.pumpApp(newTimerBloc: newTimerBloc);

      expect(find.text('${interval1.minutes} min'), findsOneWidget);
      expect(find.text('${interval2.minutes} min'), findsOneWidget);
    });

    testWidgets('renders 2 names', (tester) async {
      when(() => newTimerBloc.state).thenReturn(
        NewTimerState(
          namesStatus: NamesStatus.success,
          names: [name1, name2],
        ),
      );

      await tester.pumpApp(newTimerBloc: newTimerBloc);

      expect(find.text(name1.name), findsOneWidget);
      expect(find.text(name2.name), findsOneWidget);
    });

    testWidgets('navigates to delete dialog when interval is long pressed',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<bool>(any(that: isRoute<bool>())))
          .thenAnswer((_) async => null);
      when(() => newTimerBloc.state).thenReturn(
        NewTimerState(
            intervalsStatus: IntervalsStatus.success, intervals: [interval1]),
      );

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);
      await tester.longPress(find.text('${interval1.minutes} min'));

      verify(() => navigator.push<bool>(any(that: isRoute<bool>()))).called(1);
    });

    testWidgets('deletes interval when true is returned from dialog',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<bool>(any(that: isRoute<bool>())))
          .thenAnswer((_) async => true);
      when(() => newTimerBloc.state).thenReturn(NewTimerState(
          intervalsStatus: IntervalsStatus.success, intervals: [interval1]));

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);
      await tester.longPress(find.text('${interval1.minutes} min'));
      await tester.pumpAndSettle();

      verify(() =>
              newTimerBloc.add(NewTimerIntervalDeleted(interval: interval1)))
          .called(1);
      verify(() => newTimerBloc.add(NewTimerLoadIntervalsRequested()))
          .called(1);
    });

    testWidgets('navigates to delete dialog when name is long pressed',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<bool>(any(that: isRoute<bool>())))
          .thenAnswer((_) async => null);
      when(() => newTimerBloc.state).thenReturn(
        NewTimerState(namesStatus: NamesStatus.success, names: [name1]),
      );

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);
      await tester.longPress(find.text(name1.name));

      verify(() => navigator.push<bool>(any(that: isRoute<bool>()))).called(1);
    });

    testWidgets('deletes name when true is returned from dialog',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<bool>(any(that: isRoute<bool>())))
          .thenAnswer((_) async => true);
      when(() => newTimerBloc.state).thenReturn(
        NewTimerState(namesStatus: NamesStatus.success, names: [name1]),
      );

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);
      await tester.longPress(find.text(name1.name));
      await tester.pumpAndSettle();

      verify(() => newTimerBloc.add(NewTimerNameDeleted(name: name1)))
          .called(1);
      verify(() => newTimerBloc.add(NewTimerLoadNamesRequested())).called(1);
    });

    testWidgets('shows SnackBar with info when failure occurs with intervals',
        (tester) async {
      when(() => newTimerBloc.state).thenReturn(const NewTimerState());
      whenListen(
          newTimerBloc,
          Stream.fromIterable(
            const [
              NewTimerState(intervalsStatus: IntervalsStatus.loading),
              NewTimerState(intervalsStatus: IntervalsStatus.failure),
            ],
          ));

      await tester.pumpApp(newTimerBloc: newTimerBloc);
      await tester.pump();

      expect(
          find.descendant(
              of: find.byType(SnackBar),
              matching: find.text(l10n.newTimerFailureMessage)),
          findsOneWidget);
    });

    testWidgets('shows SnackBar with info when failure occurs with names',
        (tester) async {
      when(() => newTimerBloc.state).thenReturn(const NewTimerState());
      whenListen(
          newTimerBloc,
          Stream.fromIterable(
            const [
              NewTimerState(namesStatus: NamesStatus.loading),
              NewTimerState(namesStatus: NamesStatus.failure),
            ],
          ));

      await tester.pumpApp(newTimerBloc: newTimerBloc);
      await tester.pump();

      expect(
          find.descendant(
              of: find.byType(SnackBar),
              matching: find.text(l10n.newTimerFailureMessage)),
          findsOneWidget);
    });

    testWidgets(
        'navigates to CreateIntervalDialog when add interval button is pressed',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<int>(any())).thenAnswer((_) async => null);

      when(() => newTimerBloc.state).thenReturn(
          const NewTimerState(intervalsStatus: IntervalsStatus.success));

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);
      await tester.tap(
          find.byKey(const Key('newTimerPageCreateIntervalIconButtonKey')));

      verify(() => navigator.push<int>(any(that: isRoute<int>()))).called(1);
    });

    testWidgets('creates interval when value is returned from dialog',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<int>(any(that: isRoute<int>())))
          .thenAnswer((_) async => 20);

      when(() => newTimerBloc.state).thenReturn(
          const NewTimerState(intervalsStatus: IntervalsStatus.success));

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);
      await tester.tap(
          find.byKey(const Key('newTimerPageCreateIntervalIconButtonKey')));
      await tester.pumpAndSettle();

      verify(() => newTimerBloc.add(const NewTimerIntervalCreated(minutes: 20)))
          .called(1);
      verify(() => newTimerBloc.add(NewTimerLoadIntervalsRequested()))
          .called(1);
    });

    testWidgets('navigates to CreateNameDialog when add name button is pressed',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<String>(any())).thenAnswer((_) async => null);

      when(() => newTimerBloc.state)
          .thenReturn(const NewTimerState(namesStatus: NamesStatus.success));

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);
      await tester
          .tap(find.byKey(const Key('newTimerPageCreateNameIconButtonKey')));

      verify(() => navigator.push<String>(any(that: isRoute<String>())))
          .called(1);
    });

    testWidgets('creates name when value is returned from dialog',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<String>(any(that: isRoute<String>())))
          .thenAnswer((_) async => 'name');

      when(() => newTimerBloc.state)
          .thenReturn(const NewTimerState(namesStatus: NamesStatus.success));

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);
      await tester
          .tap(find.byKey(const Key('newTimerPageCreateNameIconButtonKey')));
      await tester.pumpAndSettle();

      verify(() => newTimerBloc.add(const NewTimerNameCreated(name: 'name')))
          .called(1);
      verify(() => newTimerBloc.add(NewTimerLoadNamesRequested())).called(1);
    });

    testWidgets('selects interval when it is tapped', (tester) async {
      when(() => newTimerBloc.state).thenReturn(NewTimerState(
          intervalsStatus: IntervalsStatus.success, intervals: [interval1]));

      await tester.pumpApp(newTimerBloc: newTimerBloc);
      await tester.tap(find.text('${interval1.minutes} min'));

      verify(() =>
              newTimerBloc.add(NewTimerIntervalSelected(interval: interval1)))
          .called(1);
    });

    testWidgets('selects name when it is tapped', (tester) async {
      when(() => newTimerBloc.state).thenReturn(
          NewTimerState(namesStatus: NamesStatus.success, names: [name1]));

      await tester.pumpApp(newTimerBloc: newTimerBloc);
      await tester.tap(find.text(name1.name));

      verify(() => newTimerBloc.add(NewTimerNameSelected(name: name1)))
          .called(1);
    });

    testWidgets('performs timer creation when FloatingActionButton is tapped',
        (tester) async {
      when(() => newTimerBloc.state).thenReturn(
        NewTimerState(selectedInterval: interval1, selectedName: name1),
      );

      await tester.pumpApp(newTimerBloc: newTimerBloc);
      await tester.tap(find.byType(FloatingActionButton));

      verify(() => newTimerBloc.add(NewTimerCreated())).called(1);
    });

    testWidgets(
        'shows SnackBar with info when error occurs during timer creation',
        (tester) async {
      when(() => newTimerBloc.state).thenReturn(const NewTimerState());
      whenListen(
          newTimerBloc,
          Stream.fromIterable(
            const [
              NewTimerState(creationStatus: CreationStatus.loading),
              NewTimerState(creationStatus: CreationStatus.failure),
            ],
          ));

      await tester.pumpApp(newTimerBloc: newTimerBloc);
      await tester.pump();

      expect(
          find.descendant(
              of: find.byType(SnackBar),
              matching: find.text(l10n.newTimerFailureMessage)),
          findsOneWidget);
    });

    testWidgets(
        'shows SnackBar with info when both interval and name are not selected '
        'during timer creation', (tester) async {
      when(() => newTimerBloc.state).thenReturn(const NewTimerState());
      whenListen(
          newTimerBloc,
          Stream.fromIterable(
            const [
              NewTimerState(creationStatus: CreationStatus.loading),
              NewTimerState(creationStatus: CreationStatus.unselected),
            ],
          ));

      await tester.pumpApp(newTimerBloc: newTimerBloc);
      await tester.pump();

      expect(
          find.descendant(
              of: find.byType(SnackBar),
              matching: find.text(l10n.newTimerUnselectedFailureMessage)),
          findsOneWidget);
    });

    testWidgets(
        'renders CircularProgressIndicator inside '
        'FloatingActionButton when creating timer', (tester) async {
      when(() => newTimerBloc.state).thenReturn(
        const NewTimerState(creationStatus: CreationStatus.loading),
      );

      await tester.pumpApp(newTimerBloc: newTimerBloc);

      expect(
          find.descendant(
              of: find.byType(FloatingActionButton),
              matching: find.byType(CircularProgressIndicator)),
          findsOneWidget);
    });

    testWidgets('pops when timer created', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop()).thenAnswer((_) async {});

      when(() => newTimerBloc.state).thenReturn(const NewTimerState());
      whenListen(
          newTimerBloc,
          Stream.fromIterable(
            const [
              NewTimerState(creationStatus: CreationStatus.loading),
              NewTimerState(creationStatus: CreationStatus.success),
            ],
          ));

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);

      verify(() => navigator.pop()).called(1);
    });

    testWidgets('pops when back button is pressed', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop()).thenAnswer((_) async {});

      when(() => newTimerBloc.state).thenReturn(const NewTimerState());

      await tester.pumpApp(newTimerBloc: newTimerBloc, navigator: navigator);
      await tester.tap(find.byIcon(Icons.arrow_back_ios));

      verify(() => navigator.pop()).called(1);
    });
  });
}
