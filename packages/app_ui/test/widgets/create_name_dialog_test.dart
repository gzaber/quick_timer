import 'package:app_ui/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers.dart';

void main() {
  group('CreateNameDialog', () {
    late MockNavigator navigator;

    setUp(() {
      navigator = MockNavigator();
    });

    buildCreateNameDialog() => const CreateNameDialog(
          title: 'Create name',
          confirmButtonText: 'Save',
          declineButtonText: 'Cancel',
          emptyNameFailureText: 'Name cannot be empty',
        );

    testWidgets('show method works', (tester) async {
      await tester.pumpTest(
        builder: (context) => IconButton(
          onPressed: () {
            CreateNameDialog.show(
              context,
              title: 'Create name',
              confirmButtonText: 'Save',
              declineButtonText: 'Cancel',
              emptyNameFailureText: 'Name cannot be empty',
            );
          },
          icon: const Icon(Icons.create),
        ),
      );

      await tester.tap(find.byIcon(Icons.create));
      await tester.pumpAndSettle();

      expect(find.byType(CreateNameDialog), findsOneWidget);
    });

    testWidgets('renders dialog', (tester) async {
      await tester.pumpTest(builder: (_) => buildCreateNameDialog());

      expect(find.byType(CreateNameDialog), findsOneWidget);
    });

    testWidgets('renders correct text', (tester) async {
      await tester.pumpTest(builder: (_) => buildCreateNameDialog());

      expect(find.text('Create name'), findsOneWidget);
    });

    testWidgets('renders correct buttons', (tester) async {
      await tester.pumpTest(builder: (_) => buildCreateNameDialog());

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

    testWidgets('shows info when text value is empty', (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: navigator,
          child: buildCreateNameDialog(),
        );
      });

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Name cannot be empty'), findsOneWidget);
    });

    testWidgets('pops with string when Save button tapped', (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: navigator,
          child: buildCreateNameDialog(),
        );
      });

      await tester.enterText(find.byType(TextFormField), 'name');
      await tester.tap(find.text('Save'));

      verify(() => navigator.pop('name')).called(1);
    });

    testWidgets('pops with null when Cancel button tapped', (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: navigator,
          child: buildCreateNameDialog(),
        );
      });

      await tester.tap(find.text('Cancel'));

      verify(() => navigator.pop(null)).called(1);
    });
  });
}
