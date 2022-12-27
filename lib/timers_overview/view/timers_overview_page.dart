import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart';

import '../../new_timer/new_timer.dart' show NewTimerPage;
import '../counter.dart';
import '../timers_overview.dart';

class TimersOverviewPage extends StatelessWidget {
  const TimersOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimersOverviewBloc(
        timersRepository: RepositoryProvider.of<TimersRepository>(context),
        counter: const Counter(),
      )..add(TimersOverviewLoadTimersRequested()),
      child: const TimersOverviewView(),
    );
  }
}

class TimersOverviewView extends StatelessWidget {
  const TimersOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimersOverviewBloc, TimersOverviewState>(
      listener: (context, state) {
        if (state.status == TimersOverviewStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Something went wrong')));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QuickTimer'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HeaderText(title: 'Most used timers'),
                _MostUsedTimers(),
                HeaderText(title: 'Other timers'),
                _Timers(),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const _CustomFloatingActionButton(),
      ),
    );
  }
}

class _MostUsedTimers extends StatelessWidget {
  const _MostUsedTimers({Key? key}) : super(key: key);

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

class _Timers extends StatelessWidget {
  const _Timers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimersOverviewBloc, TimersOverviewState>(
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
            return GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 20),
              children: List.generate(
                state.timers.length,
                (index) {
                  return _TimerItem(timer: state.timers[index]);
                },
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}

class _TimerItem extends StatelessWidget {
  const _TimerItem({
    Key? key,
    required this.timer,
  }) : super(key: key);

  final Timer timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
            .read<TimersOverviewBloc>()
            .add(TimersOverviewTimerStarted(timer: timer));
      },
      onLongPress: () {
        DeleteTimerDialog.show(context, itemName: 'timer').then((value) {
          if (value == true) {
            context.read<TimersOverviewBloc>()
              ..add(TimersOverviewTimerDeleted(timer: timer))
              ..add(TimersOverviewLoadTimersRequested());
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
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            _TimerResetButton(timer: timer),
            _TimerDuration(timer: timer),
          ],
        ),
      ),
    );
  }
}

class _TimerResetButton extends StatelessWidget {
  const _TimerResetButton({
    Key? key,
    required this.timer,
  }) : super(key: key);

  final Timer timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimersOverviewBloc, TimersOverviewState>(
      builder: (context, state) {
        if (state.timerStatus == TimerStatus.inProgress &&
            state.countdownTimer?.id == timer.id) {
          return Center(
            child: GestureDetector(
              onTap: () {
                context
                    .read<TimersOverviewBloc>()
                    .add(TimersOverviewTimerReset());
              },
              child: const Icon(
                Icons.pause,
                color: Colors.white,
                size: 20,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class _TimerDuration extends StatelessWidget {
  const _TimerDuration({
    Key? key,
    required this.timer,
  }) : super(key: key);

  final Timer timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimersOverviewBloc, TimersOverviewState>(
      builder: (context, state) {
        if (state.timerStatus == TimerStatus.inProgress &&
            state.countdownTimer?.id == timer.id) {
          final duration = Duration(seconds: state.secondsCounter);
          final minutes = duration.inMinutes.remainder(60).toString();
          final seconds =
              duration.inSeconds.remainder(60).toString().padLeft(2, '0');
          return Text(
            '$minutes:$seconds min',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          );
        }
        return Text(
          '${timer.interval.minutes} min',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        );
      },
    );
  }
}

class _CustomFloatingActionButton extends StatelessWidget {
  const _CustomFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 65,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, NewTimerPage.route()).then(
            (_) => context
                .read<TimersOverviewBloc>()
                .add(TimersOverviewLoadTimersRequested()),
          );
        },
        child: const Icon(Icons.add, size: 35),
      ),
    );
  }
}
