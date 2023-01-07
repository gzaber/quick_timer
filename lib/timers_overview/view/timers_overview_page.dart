import 'package:app_ui/app_ui.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:timers_repository/timers_repository.dart';

import '../../new_timer/new_timer.dart' show NewTimerPage;
import '../counter.dart';
import '../timers_overview.dart';

class TimersOverviewPage extends StatelessWidget {
  const TimersOverviewPage({Key? key}) : super(key: key);

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
  const TimersOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimersOverviewBloc, TimersOverviewState>(
      listener: (context, state) async {
        if (state.status == TimersOverviewStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Something went wrong')));
        }
        if (state.timerStatus == TimerStatus.completed) {
          await GetIt.I<AudioPlayer>().play(AssetSource('sound.wav'));
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
    return BlocBuilder<TimersOverviewBloc, TimersOverviewState>(
      builder: (context, state) {
        if (state.status == TimersOverviewStatus.loading) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == TimersOverviewStatus.success) {
          {
            if (state.mostUsedTimers.isEmpty) {
              return const SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    'No timers yet',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: _TimerItem(
                      timer: state.mostUsedTimers[0],
                      isMostUsed: true,
                      color: AppColors.mostUsedFirst,
                    ),
                  ),
                  if (state.mostUsedTimers.length > 1)
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: state.mostUsedTimers.length > 2
                              ? _TimerItem(
                                  timer: state.mostUsedTimers[2],
                                  isMostUsed: true,
                                  color: AppColors.mostUsedSecond,
                                )
                              : Container(),
                        ),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: _TimerItem(
                                timer: state.mostUsedTimers[1],
                                isMostUsed: true,
                                color: AppColors.mostUsedThird,
                              ),
                            )),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              );
            }
          }
        }
        return Container();
      },
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
    this.isMostUsed = false,
    this.color = AppColors.lightBlue,
  }) : super(key: key);

  final Timer timer;
  final bool isMostUsed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select((TimersOverviewBloc bloc) =>
        bloc.state.timerStatus == TimerStatus.inProgress &&
        bloc.state.countdownTimer == timer);

    return GestureDetector(
      onTap: () {
        context
            .read<TimersOverviewBloc>()
            .add(TimersOverviewTimerStarted(timer: timer));
      },
      onLongPress: () {
        DeleteItemDialog.show(context, itemName: 'timer').then((value) {
          if (value == true) {
            context.read<TimersOverviewBloc>()
              ..add(TimersOverviewTimerDeleted(timer: timer))
              ..add(TimersOverviewLoadTimersRequested());
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        height: isMostUsed ? 95 : null,
        decoration: BoxDecoration(
          color: isInProgress ? AppColors.pink : color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timer.name.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isMostUsed ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: isMostUsed ? FontWeight.bold : null,
              ),
            ),
            _TimerResetButton(timer: timer, isWhite: !isMostUsed),
            _TimerDuration(timer: timer, isWhite: !isMostUsed),
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
    this.isWhite = true,
  }) : super(key: key);

  final Timer timer;
  final bool isWhite;

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
              child: Icon(
                Icons.pause,
                color: isWhite ? Colors.white : Colors.black,
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
    this.isWhite = true,
  }) : super(key: key);

  final Timer timer;
  final bool isWhite;

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
            style: TextStyle(
              color: isWhite ? Colors.white : Colors.black,
              fontSize: 15,
            ),
          );
        }
        return Text(
          '${timer.interval.minutes} min',
          style: TextStyle(
            color: isWhite ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        );
      },
    );
  }
}

class _CustomFloatingActionButton extends StatelessWidget {
  const _CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 65,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push<void>(context, NewTimerPage.route()).then(
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
