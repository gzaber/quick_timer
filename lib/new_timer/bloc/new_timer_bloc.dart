import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_repository/timers_repository.dart';

part 'new_timer_event.dart';
part 'new_timer_state.dart';

class NewTimerBloc extends Bloc<NewTimerEvent, NewTimerState> {
  NewTimerBloc({required TimersRepository timersRepository})
      : _timersRepository = timersRepository,
        super(const NewTimerState()) {
    on<NewTimerLoadIntervalsRequested>(_onLoadIntervalsRequested);
    on<NewTimerLoadNamesRequested>(_onLoadNamesRequested);
    on<NewTimerCreated>(_onTimerCreated);
    on<NewTimerIntervalCreated>(_onIntervalCreated);
    on<NewTimerIntervalDeleted>(_onIntervalDeleted);
    on<NewTimerIntervalSelected>(_onIntervalSelected);
    on<NewTimerNameCreated>(_onNameCreated);
    on<NewTimerNameDeleted>(_onNameDeleted);
    on<NewTimerNameSelected>(_onNameSelected);
  }

  final TimersRepository _timersRepository;

  Future<void> _onLoadIntervalsRequested(
    NewTimerLoadIntervalsRequested event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(intervalsStatus: IntervalsStatus.loading));
    // TODO delete delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      final intervals = await _timersRepository.readIntervals();
      intervals.sort((a, b) => a.minutes.compareTo(b.minutes));
      emit(
        state.copyWith(
          intervalsStatus: IntervalsStatus.success,
          intervals: intervals,
        ),
      );
    } catch (e) {
      emit(state.copyWith(intervalsStatus: IntervalsStatus.failure));
    }
  }

  Future<void> _onLoadNamesRequested(
    NewTimerLoadNamesRequested event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(namesStatus: NamesStatus.loading));
    // TODO delete delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      final names = await _timersRepository.readNames();
      names
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      emit(
        state.copyWith(
          namesStatus: NamesStatus.success,
          names: names,
        ),
      );
    } catch (e) {
      emit(state.copyWith(namesStatus: NamesStatus.failure));
    }
  }

  Future<void> _onTimerCreated(
    NewTimerCreated event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(creationStatus: CreationStatus.loading));
    // TODO delete delay
    await Future.delayed(const Duration(seconds: 1));
    if (state.selectedInterval == null || state.selectedName == null) {
      emit(state.copyWith(creationStatus: CreationStatus.unselected));
      emit(state.copyWith(creationStatus: CreationStatus.initial));
      return;
    }
    try {
      await _timersRepository.createTimer(
          state.selectedInterval!, state.selectedName!);
      emit(state.copyWith(creationStatus: CreationStatus.success));
    } catch (e) {
      emit(state.copyWith(creationStatus: CreationStatus.failure));
    }
  }

  Future<void> _onIntervalCreated(
    NewTimerIntervalCreated event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(intervalsStatus: IntervalsStatus.loading));
    // TODO delete delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _timersRepository.createInterval(event.minutes);
      emit(state.copyWith(intervalsStatus: IntervalsStatus.success));
    } catch (e) {
      emit(state.copyWith(intervalsStatus: IntervalsStatus.failure));
    }
  }

  Future<void> _onIntervalDeleted(
    NewTimerIntervalDeleted event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(intervalsStatus: IntervalsStatus.loading));
    // TODO delete delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _timersRepository.deleteInterval(event.interval.id);
      emit(state.copyWith(intervalsStatus: IntervalsStatus.success));
    } catch (e) {
      emit(state.copyWith(intervalsStatus: IntervalsStatus.failure));
    }
  }

  void _onIntervalSelected(
    NewTimerIntervalSelected event,
    Emitter<NewTimerState> emit,
  ) {
    emit(state.copyWith(selectedInterval: event.interval));
  }

  Future<void> _onNameCreated(
    NewTimerNameCreated event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(namesStatus: NamesStatus.loading));
    // TODO delete delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _timersRepository.createName(event.name);
      emit(state.copyWith(namesStatus: NamesStatus.success));
    } catch (e) {
      emit(state.copyWith(namesStatus: NamesStatus.failure));
    }
  }

  Future<void> _onNameDeleted(
    NewTimerNameDeleted event,
    Emitter<NewTimerState> emit,
  ) async {
    emit(state.copyWith(namesStatus: NamesStatus.loading));
    // TODO delete delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _timersRepository.deleteName(event.name.id);
      emit(state.copyWith(namesStatus: NamesStatus.success));
    } catch (e) {
      emit(state.copyWith(namesStatus: NamesStatus.failure));
    }
  }

  void _onNameSelected(
      NewTimerNameSelected event, Emitter<NewTimerState> emit) {
    emit(state.copyWith(selectedName: event.name));
  }
}
