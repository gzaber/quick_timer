import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_timer/app/app.dart';
import 'package:quick_timer/timers_overview/timers_overview.dart';
import 'package:timers_repository/timers_repository.dart';

class MockTimersRepository extends Mock implements TimersRepository {}

void main() {
  group('App', () {
    late TimersRepository timersRepository;

    setUp(() {
      timersRepository = MockTimersRepository();
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(timersRepository: timersRepository),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late TimersRepository timersRepository;

    setUp(() {
      timersRepository = MockTimersRepository();
    });

    testWidgets('renders TimersOverviewPage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: timersRepository,
          child: const AppView(),
        ),
      );

      expect(find.byType(TimersOverviewPage), findsOneWidget);
    });
  });
}
