import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart';

import '../counter.dart';

part 'timers_overview_event.dart';
part 'timers_overview_state.dart';

class TimersOverviewBloc
    extends Bloc<TimersOverviewEvent, TimersOverviewState> {
  TimersOverviewBloc({
    required TimersRepository timersRepository,
    required Counter counter,
  })  : _timersRepository = timersRepository,
        _counter = counter,
        super(const TimersOverviewState()) {
    on<TimersOverviewLoadTimersRequested>(_onLoadTimersRequested);
    on<TimersOverviewTimerDeleted>(_onTimerDeleted);
    on<TimersOverviewTimerStarted>(_onTimerStarted);
    on<TimersOverviewTimerReset>(_onTimerReset);
    on<_TimersOverviewTimerCounted>(_onTimerCounted);
  }

  final TimersRepository _timersRepository;
  final Counter _counter;

  StreamSubscription<int>? _counterSubscription;

  @override
  Future<void> close() {
    _counterSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadTimersRequested(
    TimersOverviewLoadTimersRequested event,
    Emitter<TimersOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TimersOverviewStatus.loading));
    // TODO delete delay
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
    // TODO delete delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _timersRepository.deleteTimer(event.timer.id);
      emit(state.copyWith(status: TimersOverviewStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TimersOverviewStatus.failure));
    }
  }

  void _onTimerStarted(
    TimersOverviewTimerStarted event,
    Emitter<TimersOverviewState> emit,
  ) {
    emit(state.copyWith(
        timerStatus: TimerStatus.inProgress,
        countdownTimer: event.timer,
        secondsCounter: event.timer.interval.minutes * 60));
    _counterSubscription?.cancel();
    _counterSubscription = _counter
        .countdown(seconds: event.timer.interval.minutes * 60)
        .listen((counter) => add(_TimersOverviewTimerCounted(counter)));
  }

  void _onTimerReset(
    TimersOverviewTimerReset event,
    Emitter<TimersOverviewState> emit,
  ) {
    _counterSubscription?.cancel();
    emit(state.copyWith(
      timerStatus: TimerStatus.initial,
      countdownTimer: null,
      secondsCounter: 0,
    ));
  }

  void _onTimerCounted(
    _TimersOverviewTimerCounted event,
    Emitter<TimersOverviewState> emit,
  ) {
    if (event.secondsCounter > 0) {
      emit(state.copyWith(secondsCounter: event.secondsCounter));
    } else {
      emit(state.copyWith(timerStatus: TimerStatus.completed));
      emit(state.copyWith(
        timerStatus: TimerStatus.initial,
        countdownTimer: null,
        secondsCounter: 0,
      ));
    }
  }
}
