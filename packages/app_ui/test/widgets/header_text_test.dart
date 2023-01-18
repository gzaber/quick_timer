import 'package:app_ui/src/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  group('HeaderText', () {
    testWidgets('renders correct text', (tester) async {
      await tester.pumpTest(builder: (_) {
        return const HeaderText(title: 'Title');
      });

      expect(find.text('Title'), findsOneWidget);
    });
  });
}
