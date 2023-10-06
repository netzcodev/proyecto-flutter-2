import 'package:cars_app/features/schedules/domain/domain.dart';
import 'package:cars_app/features/schedules/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleProvider = StateNotifierProvider.autoDispose
    .family<ScheduleNotifier, ScheduleState, int>((ref, scheduleId) {
  final schedulesRepository = ref.watch(schedulesRepositoryProvider);
  return ScheduleNotifier(
    schedulesRepository: schedulesRepository,
    scheduleId: scheduleId,
  );
});

class ScheduleNotifier extends StateNotifier<ScheduleState> {
  final SchedulesRepository schedulesRepository;

  ScheduleNotifier({
    required this.schedulesRepository,
    required int scheduleId,
  }) : super(ScheduleState(id: scheduleId)) {
    loadSchedule();
  }

  Future<Schedule> _newEmptySchedule() async {
    DateTime fecha;

    if (DateTime.now().hour > 16) {
      fecha = DateTime.now().add(const Duration(days: 1));
    } else {
      fecha = DateTime.now();
    }

    final occupiedTimes = await schedulesRepository.getOccupiedTimes(fecha, 0);

    return Schedule(
      id: 0,
      customerId: 0,
      employeeId: 0,
      date: '',
      time: TimeOfDay.now(),
      name: '',
      description: '',
      services: [],
      occupiedTimes: occupiedTimes,
    );
  }

  Future<void> loadSchedule() async {
    try {
      if (state.id == 0) {
        state = state.copyWith(
          isLoading: false,
          schedule: await _newEmptySchedule(),
        );
        return;
      }

      final schedule = await schedulesRepository.getScheduleById(state.id);

      state = state.copyWith(
        isLoading: false,
        schedule: schedule,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeOccupiedTimes(DateTime fecha) async {
    final occupiedTimes =
        await schedulesRepository.getOccupiedTimes(fecha, state.id);

    state = state.copyWith(
      schedule: Schedule(
        customerId: state.schedule!.customerId,
        employeeId: state.schedule!.employeeId,
        name: state.schedule!.name,
        description: state.schedule!.description,
        services: state.schedule!.services,
        date: fecha.toString(),
        time: state.schedule!.time,
        occupiedTimes: occupiedTimes,
      ),
    );
  }
}

class ScheduleState {
  final int id;
  final Schedule? schedule;
  final bool isLoading;
  final bool isSaving;

  ScheduleState({
    required this.id,
    this.schedule,
    this.isLoading = true,
    this.isSaving = false,
  });

  ScheduleState copyWith({
    int? id,
    Schedule? schedule,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ScheduleState(
        id: id ?? this.id,
        schedule: schedule ?? this.schedule,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
