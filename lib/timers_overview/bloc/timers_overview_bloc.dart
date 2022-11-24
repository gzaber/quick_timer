import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:timers_repository/timers_repository.dart';

part 'timers_overview_event.dart';
part 'timers_overview_state.dart';

class TimersOverviewBloc
    extends Bloc<TimersOverviewEvent, TimersOverviewState> {
  TimersOverviewBloc({required TimersRepository timersRepository})
      : _timersRepository = timersRepository,
        super(const TimersOverviewState()) {
    on<TimersOverviewLoadListRequested>(_onLoadListRequested);
  }

  final TimersRepository _timersRepository;

  Future<void> _onLoadListRequested(
    TimersOverviewLoadListRequested event,
    Emitter<TimersOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TimersOverviewStatus.loading));
    await Future.delayed(Duration(seconds: 3));
    try {
      final timers = await _timersRepository.readTimers();
      emit(
        state.copyWith(status: TimersOverviewStatus.success, timers: timers),
      );
    } catch (e) {
      emit(state.copyWith(status: TimersOverviewStatus.failure));
    }
  }
}
