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
    on<NewTimerIntervalDeleted>(_onIntervalDeleted);
    on<NewTimerNameAdded>(_onNameAdded);
    on<NewTimerNameDeleted>(_onNameDeleted);
  }

  final TimersRepository _timersRepository;

  Future<void> _onLoadDataRequested(
    NewTimerLoadDataRequested event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(status: NewTimerStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      final intervals = await _timersRepository.readIntervals();
      final names = await _timersRepository.readNames();
      emit(
        state.copyWith(
          status: NewTimerStatus.success,
          intervals: intervals,
          names: names,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NewTimerStatus.failure));
    }
  }

  Future<void> _onIntervalAdded(
    NewTimerIntervalAdded event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(status: NewTimerStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
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
    }
  }

  Future<void> _onIntervalDeleted(
    NewTimerIntervalDeleted event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(status: NewTimerStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _timersRepository.deleteInterval(event.interval.id);
      final intervals = await _timersRepository.readIntervals();
      emit(
        state.copyWith(
          status: NewTimerStatus.success,
          intervals: intervals,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NewTimerStatus.failure));
    }
  }

  Future<void> _onNameAdded(
    NewTimerNameAdded event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(status: NewTimerStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _timersRepository.createName(event.name);
      final names = await _timersRepository.readNames();
      emit(
        state.copyWith(
          status: NewTimerStatus.success,
          names: names,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NewTimerStatus.failure));
    }
  }

  Future<void> _onNameDeleted(
    NewTimerNameDeleted event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(status: NewTimerStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _timersRepository.deleteName(event.name.id);
      final names = await _timersRepository.readNames();
      emit(
        state.copyWith(
          status: NewTimerStatus.success,
          names: names,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NewTimerStatus.failure));
    }
  }
}
