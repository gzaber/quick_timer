import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart';

import '../timers_overview.dart';

class TimersOverviewPage extends StatelessWidget {
  const TimersOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimersOverviewBloc(
        timersRepository: RepositoryProvider.of<TimersRepository>(context),
      )..add(TimersOverviewLoadListRequested()),
      child: const TimersOverviewView(),
    );
  }
}

class TimersOverviewView extends StatelessWidget {
  const TimersOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TimersOverviewBloc, TimersOverviewState>(
        builder: (context, state) {
          if (state.status == TimersOverviewStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == TimersOverviewStatus.success) {
            if (state.timers.isEmpty) {
              return const Center(
                child: Text(
                  'No timers yet',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Some timers exist',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          }
          if (state.status == TimersOverviewStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('Something went wrong')));
          }
          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
