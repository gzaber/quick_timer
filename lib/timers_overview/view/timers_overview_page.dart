import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart';

import '../../new_timer/new_timer.dart';
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
      appBar: AppBar(
        title: const Text('QuickTimer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: BlocConsumer<TimersOverviewBloc, TimersOverviewState>(
          listener: (context, state) {
            if (state.status == TimersOverviewStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Something went wrong')));
            }
          },
          builder: (context, state) {
            if (state.status == TimersOverviewStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == TimersOverviewStatus.success) {
              if (state.timers.isEmpty) {
                return const Center(
                  child: Text(
                    'No timers yet',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HeaderText(title: 'Most used timers'),
                      const _MostUsedTimers(),
                      const _HeaderText(title: 'Other timers'),
                      _OtherTimers(timers: state.timers),
                    ],
                  ),
                );
              }
            }
            return Container();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, NewTimerPage.route()).then(
              (_) => context
                  .read<TimersOverviewBloc>()
                  .add(TimersOverviewLoadListRequested()),
            );
          },
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ),
      ),
    );
  }
}

class _MostUsedTimers extends StatelessWidget {
  const _MostUsedTimers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      child: Center(
        child: Text(
          'No timers yet',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _OtherTimers extends StatelessWidget {
  const _OtherTimers({
    Key? key,
    required this.timers,
  }) : super(key: key);

  final List<Timer> timers;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.15,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20),
      children: List.generate(
        timers.length,
        (index) {
          return _OtherTimerItem(timer: timers[index]);
        },
      ),
    );
  }
}

class _OtherTimerItem extends StatelessWidget {
  const _OtherTimerItem({
    Key? key,
    required this.timer,
  }) : super(key: key);

  final Timer timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _DeleteDialog.show(context, itemName: 'timer').then((value) {
          if (value == true) {
            context.read<TimersOverviewBloc>()
              ..add(TimersOverviewTimerDeleted(timer: timer))
              ..add(TimersOverviewLoadListRequested());
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF343D58),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timer.name.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              '${timer.interval.minutes} min',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({
    Key? key,
    required this.itemName,
  }) : super(key: key);

  final String itemName;

  static Future<bool?> show(BuildContext context, {required String itemName}) {
    return showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _DeleteDialog(itemName: itemName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete'),
      content: Text('Delete $itemName?'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop<bool>(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop<bool>(context, true),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
