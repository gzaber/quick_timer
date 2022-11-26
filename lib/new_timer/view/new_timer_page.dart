import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart' as repo;

import '../new_timer.dart';

class NewTimerPage extends StatelessWidget {
  const NewTimerPage({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const NewTimerPage(),
      settings: const RouteSettings(name: '/new_timer'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewTimerBloc(
        timersRepository: RepositoryProvider.of<repo.TimersRepository>(context),
      )..add(NewTimerLoadDataRequested()),
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: 25,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: SizedBox(
          width: MediaQuery.of(context).size.width - 70,
          child: const Center(
            child: Text(
              'Add to timer',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderText(title: 'Select time'),
            Container(
              height: 103,
              margin: const EdgeInsets.only(top: 20, bottom: 30),
              child: BlocConsumer<NewTimerBloc, NewTimerState>(
                builder: (context, state) {
                  if (state.status == NewTimerStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.status == NewTimerStatus.success) {
                    return _Intervals(intervals: state.intervals);
                  }
                  return Container();
                },
                listener: (context, state) {
                  if (state.status == NewTimerStatus.failure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                          content: Text('Something went wrong')));
                  }
                },
              ),
            ),
            const _HeaderText(title: 'Name'),
            BlocBuilder<NewTimerBloc, NewTimerState>(
              builder: (context, state) {
                if (state.status == NewTimerStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.status == NewTimerStatus.success) {
                  return _Names(names: state.names);
                }
                return Container();
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
          return Column(
            children: [
              const SizedBox(height: 15),
              IconButton(
                onPressed: () {
                  _CreateIntervalDialog.show(context, title: 'Select minutes')
                      .then(
                    (value) {
                      if (value != null) {
                        context
                            .read<NewTimerBloc>()
                            .add(NewTimerIntervalAdded(minutes: value));
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
        } else {
          return GestureDetector(
            onLongPress: () {
              _DeleteDialog.show(context, itemName: 'interval').then((value) {
                if (value == true) {
                  context
                      .read<NewTimerBloc>()
                      .add(NewTimerIntervalDeleted(interval: intervals[index]));
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                  ),
                  Text(
                    '${intervals[index].minutes} min',
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
      },
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Wrap(
        children: List.generate(
          names.length + 1,
          (index) {
            if (index == names.length) {
              return IconButton(
                onPressed: () {
                  _CreateNameDialog.show(context, title: 'Create name').then(
                    (value) {
                      if (value != null) {
                        context
                            .read<NewTimerBloc>()
                            .add(NewTimerNameAdded(name: value));
                      }
                    },
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              );
            } else {
              return GestureDetector(
                onLongPress: () {
                  _DeleteDialog.show(context, itemName: 'name').then((value) {
                    if (value == true) {
                      context
                          .read<NewTimerBloc>()
                          .add(NewTimerNameDeleted(name: names[index]));
                    }
                  });
                },
                child: Container(
                  color: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: const EdgeInsets.only(right: 10, top: 10),
                  child: Text(names[index].name),
                ),
              );
            }
          },
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

class _CreateNameDialog extends StatelessWidget {
  const _CreateNameDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  static Future<String?> show(BuildContext context, {required String title}) {
    return showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _CreateNameDialog(title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: nameController,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, nameController.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _CreateIntervalDialog extends StatefulWidget {
  const _CreateIntervalDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  static Future<int?> show(BuildContext context, {required String title}) {
    return showDialog<int>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _CreateIntervalDialog(title: title),
    );
  }

  @override
  State<_CreateIntervalDialog> createState() => _CreateIntervalDialogState();
}

class _CreateIntervalDialogState extends State<_CreateIntervalDialog> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 60,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  activeIndex = index;
                });
              },
              child: Container(
                width: 50,
                color: activeIndex == index ? Colors.teal : Colors.pink,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: Text('${index + 1}')),
              ),
            );
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, activeIndex + 1),
          child: const Text('Save'),
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
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
