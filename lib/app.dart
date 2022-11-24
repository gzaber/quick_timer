import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart';

import 'timers_overview/view/view.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.timersRepository,
  }) : super(key: key);

  final TimersRepository timersRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: timersRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF020E35),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF82A1),
        ),
      ),
      title: 'Quick Timer',
      home: const TimersOverviewPage(),
    );
  }
}
