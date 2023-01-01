import 'package:flutter/material.dart';

import '../colors/colors.dart';

abstract class AppTheme {
  static final theme = ThemeData(
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
}
