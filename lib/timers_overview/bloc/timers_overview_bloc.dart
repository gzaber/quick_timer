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
    try {
      final timers = await _timersRepository.readTimers();
      List<Timer> mostUsedTimers = const [];
      if (timers.length > 3) {
        var tmpTimers =
            timers.where((timer) => timer.startupCounter > 0).toList();
        tmpTimers.sort((a, b) => a.startupCounter.compareTo(b.startupCounter));
        mostUsedTimers = tmpTimers.reversed.take(3).toList();
        for (final timer in mostUsedTimers) {
          timers.remove(timer);
        }
      }
      timers.sort((a, b) =>
          a.name.name.toLowerCase().compareTo(b.name.name.toLowerCase()));
      emit(state.copyWith(
          status: TimersOverviewStatus.success,
          timers: timers,
          mostUsedTimers: mostUsedTimers));
    } catch (e) {
      emit(state.copyWith(status: TimersOverviewStatus.failure));
    }
  }

  Future<void> _onTimerDeleted(
    TimersOverviewTimerDeleted event,
    Emitter<TimersOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TimersOverviewStatus.loading));
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
  ) async {
    try {
      await _timersRepository.incrementStartupCounter(event.timer);
    } catch (e) {
      emit(state.copyWith(status: TimersOverviewStatus.failure));
    }
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
  ) async {
    if (event.secondsCounter > 0) {
      emit(state.copyWith(secondsCounter: event.secondsCounter));
    } else {
      emit(state.copyWith(timerStatus: TimerStatus.completed));
      try {
        await _timersRepository.incrementStartupCounter(state.countdownTimer!);
        emit(state.copyWith(
          timerStatus: TimerStatus.initial,
          countdownTimer: null,
          secondsCounter: 0,
        ));
      } catch (e) {
        emit(state.copyWith(status: TimersOverviewStatus.failure));
      }
    }
  }
}
