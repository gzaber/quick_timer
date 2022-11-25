import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:timers_repository/timers_repository.dart';

part 'new_timer_event.dart';
part 'new_timer_state.dart';

class NewTimerBloc extends Bloc<NewTimerEvent, NewTimerState> {
  NewTimerBloc({required TimersRepository timersRepository})
      : _timersRepository = timersRepository,
        super(const NewTimerState()) {
    on<NewTimerLoadDataRequested>(_onLoadDataRequested);
    on<NewTimerIntervalAdded>(_onIntervalAdded);
  }

  final TimersRepository _timersRepository;

  Future<void> _onLoadDataRequested(
    NewTimerLoadDataRequested event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(status: NewTimerStatus.loading));
    await Future.delayed(const Duration(seconds: 2));
    try {
      final intervals = await _timersRepository.readIntervals();
      print('before names');
      final names = await _timersRepository.readNames();
      print('after names');
      emit(
        state.copyWith(
          status: NewTimerStatus.success,
          intervals: intervals,
          names: names,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NewTimerStatus.failure));
      print(e.toString());
    }
  }

  Future<void> _onIntervalAdded(
    NewTimerIntervalAdded event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(status: NewTimerStatus.loading));
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _timersRepository.createInterval(event.minutes);
      final intervals = await _timersRepository.readIntervals();
      emit(
        state.copyWith(
          status: NewTimerStatus.success,
          intervals: intervals,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NewTimerStatus.failure));
      print(e.toString());
    }
  }
}
