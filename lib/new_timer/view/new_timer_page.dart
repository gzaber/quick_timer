import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart' as repo;

import '../new_timer.dart';

class NewTimerPage extends StatelessWidget {
  const NewTimerPage({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const NewTimerPage(),
      settings: const RouteSettings(name: '/new_timer'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewTimerBloc(
        timersRepository: RepositoryProvider.of<repo.TimersRepository>(context),
      )
        ..add(NewTimerLoadIntervalsRequested())
        ..add(NewTimerLoadNamesRequested()),
      child: const NewTimerView(),
    );
  }
}

class NewTimerView extends StatelessWidget {
  const NewTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Timer'),
        toolbarHeight: 107,
        leading: IconButton(
          onPressed: () => Navigator.pop<void>(context),
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: 25,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocConsumer<NewTimerBloc, NewTimerState>(
        listener: (context, state) {
          if (state.creationStatus == CreationStatus.success) {
            Navigator.pop(context);
          }
          if (state.creationStatus == CreationStatus.unselected) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('Both interval and name should be selected')));
          }
          if (state.creationStatus == CreationStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('Something went wrong during timer creation')));
          }
        },
        builder: (context, state) {
          return FloatingActionButton.extended(
            onPressed: () {
              context.read<NewTimerBloc>().add(NewTimerCreated());
            },
            label: SizedBox(
              width: MediaQuery.of(context).size.width - 70,
              child: Center(
                child: state.creationStatus == CreationStatus.loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Add to timer',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HeaderText(title: 'Select time'),
            Container(
              height: 103,
              margin: const EdgeInsets.only(top: 20, bottom: 30),
              child: BlocConsumer<NewTimerBloc, NewTimerState>(
                builder: (context, state) {
                  if (state.intervalsStatus == IntervalsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.intervalsStatus == IntervalsStatus.success) {
                    return _Intervals(intervals: state.intervals);
                  }
                  return Container();
                },
                listener: (context, state) {
                  if (state.intervalsStatus == IntervalsStatus.failure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                          content:
                              Text('Something went wrong with intervals')));
                  }
                },
              ),
            ),
            const HeaderText(title: 'Name'),
            BlocConsumer<NewTimerBloc, NewTimerState>(
              builder: (context, state) {
                if (state.namesStatus == NamesStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.namesStatus == NamesStatus.success) {
                  return _Names(names: state.names);
                }
                return Container();
              },
              listener: (context, state) {
                if (state.namesStatus == NamesStatus.failure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                        content: Text('Something went wrong with names')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Intervals extends StatelessWidget {
  const _Intervals({
    Key? key,
    required this.intervals,
  }) : super(key: key);

  final List<repo.Interval> intervals;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true,
      itemCount: intervals.length + 1,
      itemBuilder: (context, index) {
        if (index == intervals.length) {
          return const _CreateIntervalButton();
        } else {
          return _IntervalItem(interval: intervals[index]);
        }
      },
    );
  }
}

class _IntervalItem extends StatelessWidget {
  const _IntervalItem({
    Key? key,
    required this.interval,
  }) : super(key: key);

  final repo.Interval interval;

  @override
  Widget build(BuildContext context) {
    final selectedInterval =
        context.select((NewTimerBloc bloc) => bloc.state.selectedInterval);

    return GestureDetector(
      onTap: () {
        context
            .read<NewTimerBloc>()
            .add(NewTimerIntervalSelected(interval: interval));
      },
      onLongPress: () {
        DeleteItemDialog.show(context, itemName: 'interval').then((value) {
          if (value == true) {
            context.read<NewTimerBloc>()
              ..add(NewTimerIntervalDeleted(interval: interval))
              ..add(NewTimerLoadIntervalsRequested());
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: const BoxDecoration(
                    color: Color(0xFF111B3E),
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                CustomPaint(
                  painter: _CircleSectorPainter(
                    minutes: interval.minutes,
                    color: selectedInterval == interval
                        ? const Color(0xFFFF82A1)
                        : const Color(0xFF233266),
                  ),
                ),
              ],
            ),
            Text(
              '${interval.minutes} min',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleSectorPainter extends CustomPainter {
  _CircleSectorPainter({
    required this.minutes,
    required this.color,
  });

  final int minutes;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const rect = Rect.fromLTRB(0, 0, 75, 75);
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * minutes / 60;
    const useCenter = true;
    final paint = Paint()..color = color;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class _CreateIntervalButton extends StatelessWidget {
  const _CreateIntervalButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        IconButton(
          onPressed: () {
            CreateIntervalDialog.show(context, title: 'Select minutes').then(
              (value) {
                if (value != null) {
                  context.read<NewTimerBloc>()
                    ..add(NewTimerIntervalCreated(minutes: value))
                    ..add(NewTimerLoadIntervalsRequested());
                }
              },
            );
          },
          icon: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _Names extends StatelessWidget {
  const _Names({
    Key? key,
    required this.names,
  }) : super(key: key);

  final List<repo.Name> names;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Wrap(
        spacing: 10,
        runSpacing: 15,
        children: List.generate(
          names.length + 1,
          (index) {
            if (index == names.length) {
              return const _CreateNameButton();
            } else {
              return _NameItem(name: names[index]);
            }
          },
        ),
      ),
    );
  }
}

class _NameItem extends StatelessWidget {
  const _NameItem({
    Key? key,
    required this.name,
  }) : super(key: key);

  final repo.Name name;

  @override
  Widget build(BuildContext context) {
    final selectedName =
        context.select((NewTimerBloc bloc) => bloc.state.selectedName);

    return GestureDetector(
      onTap: () {
        context.read<NewTimerBloc>().add(NewTimerNameSelected(name: name));
      },
      onLongPress: () {
        DeleteItemDialog.show(context, itemName: 'name').then((value) {
          if (value == true) {
            context.read<NewTimerBloc>()
              ..add(NewTimerNameDeleted(name: name))
              ..add(NewTimerLoadNamesRequested());
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: name == selectedName
              ? const Color(0xFFFF82A1)
              : const Color(0xFF343D58),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          name.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _CreateNameButton extends StatelessWidget {
  const _CreateNameButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: IconButton(
        onPressed: () {
          CreateNameDialog.show(context, title: 'Create name').then(
            (value) {
              if (value != null) {
                context.read<NewTimerBloc>()
                  ..add(NewTimerNameCreated(name: value))
                  ..add(NewTimerLoadNamesRequested());
              }
            },
          );
        },
        icon: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        splashRadius: 25,
      ),
    );
  }
}
