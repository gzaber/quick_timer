import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpTest({required WidgetBuilder builder}) async {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: builder,
          ),
        ),
      ),
    );
  }
}
