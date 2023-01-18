import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    final theme = ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        titleSpacing: 0,
      ),
      scaffoldBackgroundColor: AppColors.backgroundBlue,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.pink,
      ),
    );

    test('has correct theme', () {
      expect(AppTheme.theme, equals(theme));
    });
  });
}
