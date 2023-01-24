import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timers_repository/timers_repository.dart';

import '../timers_overview/timers_overview.dart';

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
      theme: AppTheme.theme,
      title: 'QuickTimer',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const TimersOverviewPage(),
    );
  }
}
