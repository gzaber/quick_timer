import 'package:app_ui/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers.dart';

void main() {
  group('CreateIntervalDialog', () {
    late MockNavigator navigator;

    setUp(() {
      navigator = MockNavigator();
    });

    testWidgets('show method works', (tester) async {
      await tester.pumpTest(
        builder: (context) => IconButton(
          onPressed: () {
            CreateIntervalDialog.show(context, title: 'Interval');
          },
          icon: const Icon(Icons.create),
        ),
      );

      await tester.tap(find.byIcon(Icons.create));
      await tester.pumpAndSettle();

      expect(find.byType(CreateIntervalDialog), findsOneWidget);
    });

    testWidgets('renders dialog', (tester) async {
      await tester.pumpTest(
          builder: (_) => const CreateIntervalDialog(title: 'Interval'));

      expect(find.byType(CreateIntervalDialog), findsOneWidget);
    });

    testWidgets('renders correct text', (tester) async {
      await tester.pumpTest(
          builder: (_) => const CreateIntervalDialog(title: 'Interval'));

      expect(find.text('Interval'), findsOneWidget);
    });

    testWidgets('renders correct buttons', (tester) async {
      await tester.pumpTest(
          builder: (_) => const CreateIntervalDialog(title: 'Interval'));

      expect(find.byType(TextButton), findsNWidgets(2));
      expect(
        find.descendant(
            of: find.byType(TextButton), matching: find.text('Save')),
        findsOneWidget,
      );
      expect(
        find.descendant(
            of: find.byType(TextButton), matching: find.text('Cancel')),
        findsOneWidget,
      );
    });

    testWidgets('pops with int when Save button tapped', (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: navigator,
          child: const CreateIntervalDialog(title: 'Interval'),
        );
      });

      await tester.tap(find.text('3'));
      await tester.tap(find.text('Save'));

      verify(() => navigator.pop(3)).called(1);
    });

    testWidgets('pops with null when Cancel button tapped', (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: navigator,
          child: const CreateIntervalDialog(title: 'Interval'),
        );
      });

      await tester.tap(find.text('Cancel'));

      verify(() => navigator.pop(null)).called(1);
    });
  });
}
