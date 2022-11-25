import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart' as repository;

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
        timersRepository:
            RepositoryProvider.of<repository.TimersRepository>(context),
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: 25,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(title: 'Select time'),
          SizedBox(
            height: 140,
            child: BlocConsumer<NewTimerBloc, NewTimerState>(
              builder: (context, state) {
                if (state.status == NewTimerStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.status == NewTimerStatus.success) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // reverse: true,
                    itemCount: state.intervals.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.intervals.length) {
                        return IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Create interval'),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  actions: [
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 10);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            ).then((value) => context
                                .read<NewTimerBloc>()
                                .add(NewTimerIntervalAdded(minutes: value)));
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.pink,
                          margin: const EdgeInsets.all(10),
                          child: Center(
                              child: Text(
                                  '${state.intervals[index].minutes} min')),
                        );
                      }
                    },
                  );
                }
                return Container();
              },
              listener: (context, state) {
                if (state.status == NewTimerStatus.failure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(content: Text('Something went wrong')));
                }
              },
            ),
          ),
          const _Header(title: 'Name'),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
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
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
