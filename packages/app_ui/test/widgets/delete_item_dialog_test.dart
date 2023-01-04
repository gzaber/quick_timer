import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers.dart';

void main() {
  group('DeleteItemDialog', () {
    late MockNavigator navigator;

    setUp(() {
      navigator = MockNavigator();
    });

    testWidgets('show method works', (tester) async {
      await tester.pumpTest(
        builder: (context) => IconButton(
          onPressed: () {
            DeleteItemDialog.show(context, itemName: 'itemName');
          },
          icon: const Icon(Icons.delete),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteItemDialog), findsOneWidget);
    });

    testWidgets('renders dialog', (tester) async {
      await tester.pumpTest(
          builder: (_) => const DeleteItemDialog(itemName: 'itemName'));

      expect(find.byType(DeleteItemDialog), findsOneWidget);
    });

    testWidgets('renders correct text', (tester) async {
      await tester.pumpTest(
          builder: (_) => const DeleteItemDialog(itemName: 'itemName'));

      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Delete itemName?'), findsOneWidget);
    });

    testWidgets('renders correct buttons', (tester) async {
      await tester.pumpTest(
          builder: (_) => const DeleteItemDialog(itemName: 'itemName'));

      expect(find.byType(TextButton), findsNWidgets(2));
      expect(
        find.descendant(of: find.byType(TextButton), matching: find.text('OK')),
        findsOneWidget,
      );
      expect(
        find.descendant(
            of: find.byType(TextButton), matching: find.text('Cancel')),
        findsOneWidget,
      );
    });

    testWidgets('pops with true when OK button tapped', (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: navigator,
          child: const DeleteItemDialog(itemName: 'itemName'),
        );
      });

      await tester.tap(find.text('OK'));

      verify(() => navigator.pop(true)).called(1);
    });

    testWidgets('pops with false when Cancel button tapped', (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: navigator,
          child: const DeleteItemDialog(itemName: 'itemName'),
        );
      });

      await tester.tap(find.text('Cancel'));

      verify(() => navigator.pop(false)).called(1);
    });
  });
}
