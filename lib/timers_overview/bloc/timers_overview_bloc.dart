import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart';

part 'timers_overview_event.dart';
part 'timers_overview_state.dart';

class TimersOverviewBloc
    extends Bloc<TimersOverviewEvent, TimersOverviewState> {
  TimersOverviewBloc({required TimersRepository timersRepository})
      : _timersRepository = timersRepository,
        super(const TimersOverviewState()) {
    on<TimersOverviewLoadTimersRequested>(_onLoadTimersRequested);
    on<TimersOverviewTimerDeleted>(_onTimerDeleted);
  }

  final TimersRepository _timersRepository;

  Future<void> _onLoadTimersRequested(
    TimersOverviewLoadTimersRequested event,
    Emitter<TimersOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TimersOverviewStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      final timers = await _timersRepository.readTimers();
      emit(
          state.copyWith(status: TimersOverviewStatus.success, timers: timers));
    } catch (e) {
      emit(state.copyWith(status: TimersOverviewStatus.failure));
    }
  }

  Future<void> _onTimerDeleted(
    TimersOverviewTimerDeleted event,
    Emitter<TimersOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TimersOverviewStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _timersRepository.deleteTimer(event.timer.id);
      emit(state.copyWith(status: TimersOverviewStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TimersOverviewStatus.failure));
    }
  }
}
