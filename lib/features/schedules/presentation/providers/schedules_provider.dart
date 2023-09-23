import 'dart:collection';
import 'package:cars_app/features/people/people.dart';
import 'package:cars_app/features/schedules/domain/domain.dart';
import 'package:cars_app/features/schedules/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final schedulesProvider =
    StateNotifierProvider.autoDispose<SchedulesNotifier, SchedulesState>((ref) {
  final schedulesRepository = ref.watch(schedulesRepositoryProvider);
  ref.watch(peopleProvider.notifier).firstLoad();
  return SchedulesNotifier(schedulesRepository: schedulesRepository);
});

class SchedulesNotifier extends StateNotifier<SchedulesState> {
  final SchedulesRepository schedulesRepository;
  SchedulesNotifier({
    required this.schedulesRepository,
  }) : super(
          SchedulesState(
            selectedDay: DateTime.now(),
            focusedDay: ValueNotifier(DateTime.now()),
            kToday: DateTime.now(),
            kFirstDay: DateTime(DateTime.now().year, DateTime.now().month - 3,
                DateTime.now().day),
            kLastDay: DateTime(DateTime.now().year, DateTime.now().month + 3,
                DateTime.now().day),
            selectedDays: LinkedHashSet<DateTime>(
              equals: isSameDay,
              hashCode: _getHashCode,
            ),
            weekNumber: _getWeekNumber(DateTime.now()),
            generalWeekNumber: _getWeekNumber(DateTime.now()),
            generalEvents: LinkedHashMap<DateTime, List<Schedule>>(),
          ),
        ) {
    firstLoad();
  }

  Future<bool> createOrUpdateSchedules(
      Map<String, dynamic> scheduleLike) async {
    try {
      final schedule =
          await schedulesRepository.createUpdateSchedules(scheduleLike);

      final scheduleDate = schedule.date;

      if (state.kEvents?.containsKey(scheduleDate) == true) {
        final updatedEvents = state.kEvents?[scheduleDate] ?? [];
        final index =
            updatedEvents.indexWhere((event) => event.id == schedule.id);
        if (index >= 0) {
          updatedEvents[index] = schedule;
        } else {
          updatedEvents.add(schedule);
        }

        final updatedMap =
            LinkedHashMap<DateTime, List<Schedule>>.from(state.kEvents ?? {});
        updatedMap[DateTime.parse(scheduleDate)] = updatedEvents;
        state = state.copyWith(
          kEvents: updatedMap,
          selectedEvents: ValueNotifier(
            getEventsForDays(state.selectedDays),
          ),
        );
      } else {
        final newMap =
            LinkedHashMap<DateTime, List<Schedule>>.from(state.kEvents ?? {});
        newMap[DateTime.parse(scheduleDate)] = [schedule];
        state = state.copyWith(
          kEvents: newMap,
          selectedEvents: ValueNotifier(
            getEventsForDays(state.selectedDays),
          ),
        );
      }

      resetState();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSchedules(int id) async {
    try {
      final schedule = await schedulesRepository.deleteSchedule(id);

      if (state.kEvents != null) {
        final updatedKEvents =
            LinkedHashMap<DateTime, List<Schedule>>.from(state.kEvents!);

        final scheduleDate = DateTime.parse(schedule['date']);

        if (updatedKEvents.containsKey(scheduleDate)) {
          final updatedEvents = updatedKEvents[scheduleDate] ?? [];
          updatedEvents.removeWhere(
            (event) => event.id == int.parse(schedule['id']),
          );

          // Actualizar kEvents con los eventos actualizados
          if (updatedEvents.isEmpty) {
            updatedKEvents.remove(scheduleDate);
          } else {
            updatedKEvents[scheduleDate] = updatedEvents;
          }

          // Actualizar el estado con los cambios
          state = state.copyWith(
            kEvents: updatedKEvents,
            selectedEvents: ValueNotifier(
              getEventsForDays(state.selectedDays),
            ),
          );
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future onWeekNumberChange(int weekNumber) async {
    state = state.copyWith(isLoading: true, weekNumber: weekNumber);

    final newSchedules =
        await schedulesRepository.getSchedulesByWeek(weekNumber);

    if (newSchedules.isEmpty) {
      state = state.copyWith(
        isLoading: false,
      );
      return;
    }

    final updatedKEvents =
        LinkedHashMap<DateTime, List<Schedule>>.from(state.kEvents ?? {});

    for (final schedule in newSchedules) {
      final scheduleDate = DateTime.parse(schedule.date);

      // Verificar si el día ya existe en kEvents
      if (updatedKEvents.containsKey(scheduleDate)) {
        final updatedEvents = updatedKEvents[scheduleDate] ?? [];
        final index =
            updatedEvents.indexWhere((event) => event.id == schedule.id);

        // Actualizar o agregar el evento según corresponda
        if (index >= 0) {
          updatedEvents[index] = schedule;
        } else {
          updatedEvents.add(schedule);
        }
        updatedKEvents[scheduleDate] = updatedEvents;
      } else {
        updatedKEvents[scheduleDate] = [schedule];
      }
    }

    // Actualizar el estado con los eventos de la semana seleccionada
    state = state.copyWith(
      isLoading: false,
      kEvents: updatedKEvents,
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    Set<DateTime> bagDays = state.selectedDays;
    if (bagDays.contains(selectedDay)) {
      bagDays.remove(selectedDay);
    } else {
      bagDays.add(selectedDay);
    }
    print(bagDays);
    state = state.copyWith(
      selectedDays: bagDays,
      focusedDay: ValueNotifier(focusedDay),
      rangeStart: null,
      rangeEnd: null,
      rangeSelectionMode: RangeSelectionMode.toggledOff,
      selectedEvents: ValueNotifier(getEventsForDays(bagDays)),
    );
  }

  List<Schedule> getEventsForDay(DateTime day) {
    DateTime formattedDate = DateTime.parse(
      '${day.year}-${_twoDigits(day.month)}-${_twoDigits(day.day)} ${_twoDigits(day.hour)}:${_twoDigits(day.minute)}:${_twoDigits(day.second)}',
    );

    return state.kEvents?[formattedDate] ?? [];
  }

  List<Schedule> getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ...getEventsForDay(d),
    ];
  }

  List<Schedule> getEventsForRange(DateTime start, DateTime end) {
    final days = _daysInRange(start, end);

    return [
      for (final d in days) ...getEventsForDay(d),
    ];
  }

  List<DateTime> _daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    List<Schedule> eventsBag = [];

    if (start != null && end != null) {
      eventsBag = getEventsForRange(start, end);
    } else if (start != null) {
      eventsBag = getEventsForDay(start);
    } else if (end != null) {
      eventsBag = getEventsForDay(end);
    }

    state = state.copyWith(
      focusedDay: ValueNotifier(focusedDay),
      rangeStart: start,
      rangeEnd: end,
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      selectedDays: {},
      selectedEvents: ValueNotifier(eventsBag),
    );
  }

  void onFocusedDayChange(DateTime focusedDay) {
    state = state.copyWith(focusedDay: ValueNotifier(focusedDay));
  }

  CalendarFormat onFormatChanged(CalendarFormat format) {
    if (state.calendarFormat != format) {
      state = state.copyWith(calendarFormat: format);
    }

    return state.calendarFormat;
  }

  void resetState() {
    Null nuller;

    state = state.copyWith(
      selectedDays: {},
      focusedDay: ValueNotifier(DateTime.now()),
      rangeStart: nuller,
      rangeEnd: nuller,
      rangeSelectionMode: RangeSelectionMode.toggledOff,
      selectedEvents: ValueNotifier(getEventsForDays([DateTime.now()])),
    );
  }

  bool canClearSelection() {
    return state.selectedDays.isNotEmpty ||
        state.rangeStart != null ||
        state.rangeEnd != null;
  }

  Future firstLoad() async {
    if (!state.isFirstLoad) return;
    state = state.copyWith(isLoading: true, isFirstLoad: false);

    final newSchedules =
        await schedulesRepository.getSchedulesByWeek(state.weekNumber);

    if (newSchedules.isEmpty) {
      state = state.copyWith(
        isLoading: false,
      );
      return;
    }

    final updatedKEvents =
        LinkedHashMap<DateTime, List<Schedule>>.from(state.kEvents ?? {});

    for (final schedule in newSchedules) {
      final scheduleDate = DateTime.parse(schedule.date);

      // Verificar si el día ya existe en kEvents
      if (updatedKEvents.containsKey(scheduleDate)) {
        final updatedEvents = updatedKEvents[scheduleDate] ?? [];
        final index =
            updatedEvents.indexWhere((event) => event.id == schedule.id);

        // Actualizar o agregar el evento según corresponda
        if (index >= 0) {
          updatedEvents[index] = schedule;
        } else {
          updatedEvents.add(schedule);
        }
        updatedKEvents[scheduleDate] = updatedEvents;
      } else {
        updatedKEvents[scheduleDate] = [schedule];
      }
    }

    // Actualizar el estado con los eventos de la semana seleccionada
    state = state.copyWith(
      isLoading: false,
      kEvents: updatedKEvents,
      generalEvents: updatedKEvents,
    );
  }

  Future loadNextWeek() async {
    state = state.copyWith(
        isLoading: true, generalWeekNumber: state.generalWeekNumber + 1);

    final newSchedules =
        await schedulesRepository.getSchedulesByWeek(state.generalWeekNumber);

    if (newSchedules.isEmpty) {
      state = state.copyWith(
        isLoading: false,
      );
      return;
    }

    final updatedGeneralEvents =
        LinkedHashMap<DateTime, List<Schedule>>.from(state.generalEvents);

    for (final schedule in newSchedules) {
      final scheduleDate = DateTime.parse(schedule.date);

      if (updatedGeneralEvents.containsKey(scheduleDate)) {
        final updatedEvents = updatedGeneralEvents[scheduleDate] ?? [];
        final index =
            updatedEvents.indexWhere((event) => event.id == schedule.id);

        // Actualizar o agregar el evento según corresponda
        if (index >= 0) {
          updatedEvents[index] = schedule;
        } else {
          updatedEvents.add(schedule);
        }
        updatedGeneralEvents[scheduleDate] = updatedEvents;
      } else {
        updatedGeneralEvents[scheduleDate] = [schedule];
      }
    }

    // Actualizar el estado con los eventos de la semana seleccionada
    state = state.copyWith(
      isLoading: false,
      generalEvents: updatedGeneralEvents,
    );
  }
}

class SchedulesState {
  final bool isFirstLoad;
  final bool isLoading;
  final DateTime selectedDay;
  final ValueNotifier<DateTime> focusedDay;
  final ValueNotifier<List<Schedule>>? selectedEvents;
  final LinkedHashMap<DateTime, List<Schedule>>? kEvents;
  final LinkedHashMap<DateTime, List<Schedule>> generalEvents;
  final CalendarFormat calendarFormat;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final RangeSelectionMode rangeSelectionMode;
  final DateTime kToday;
  final DateTime kFirstDay;
  final DateTime kLastDay;
  final Set<DateTime> selectedDays;
  final int weekNumber;
  final int generalWeekNumber;

  SchedulesState({
    this.isFirstLoad = true,
    this.isLoading = false,
    required this.selectedDay,
    required this.focusedDay,
    this.selectedEvents,
    this.kEvents,
    required this.generalEvents,
    this.calendarFormat = CalendarFormat.week,
    this.rangeStart,
    this.rangeEnd,
    this.rangeSelectionMode = RangeSelectionMode.toggledOff,
    required this.kToday,
    required this.kFirstDay,
    required this.kLastDay,
    required this.selectedDays,
    required this.weekNumber,
    required this.generalWeekNumber,
  });

  DateTime newMethod() => DateTime.now();

  SchedulesState copyWith(
          {bool? isFirstLoad,
          bool? isLoading,
          DateTime? selectedDay,
          ValueNotifier<DateTime>? focusedDay,
          ValueNotifier<List<Schedule>>? selectedEvents,
          LinkedHashMap<DateTime, List<Schedule>>? kEvents,
          LinkedHashMap<DateTime, List<Schedule>>? generalEvents,
          CalendarFormat? calendarFormat,
          DateTime? rangeStart,
          DateTime? rangeEnd,
          RangeSelectionMode? rangeSelectionMode,
          DateTime? kToday,
          DateTime? kFirstDay,
          DateTime? kLastDay,
          Set<DateTime>? selectedDays,
          int? weekNumber,
          int? generalWeekNumber}) =>
      SchedulesState(
        isFirstLoad: isFirstLoad ?? this.isFirstLoad,
        isLoading: isLoading ?? this.isLoading,
        selectedDay: selectedDay ?? this.selectedDay,
        focusedDay: focusedDay ?? this.focusedDay,
        selectedEvents: selectedEvents ?? this.selectedEvents,
        kEvents: kEvents ?? this.kEvents,
        generalEvents: generalEvents ?? this.generalEvents,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
        rangeSelectionMode: rangeSelectionMode ?? this.rangeSelectionMode,
        kToday: kToday ?? this.kToday,
        kFirstDay: kFirstDay ?? this.kFirstDay,
        kLastDay: kLastDay ?? this.kLastDay,
        calendarFormat: calendarFormat ?? this.calendarFormat,
        selectedDays: selectedDays ?? this.selectedDays,
        weekNumber: weekNumber ?? this.weekNumber,
        generalWeekNumber: generalWeekNumber ?? this.generalWeekNumber,
      );
}

int _getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

int _getWeekNumber(DateTime date) {
  final year = date.year;
  final firstDayOfYear = DateTime(year, 1, 1);
  final days = date.difference(firstDayOfYear).inDays;
  final weekNumber = ((days - date.weekday + 10) / 7).floor();
  return weekNumber;
}

String _twoDigits(int n) {
  if (n >= 10) {
    return '$n';
  } else {
    return '0$n';
  }
}
