import 'dart:collection';
import 'package:cars_app/features/calendar/domain/domail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final calendarProvider =
    StateNotifierProvider.autoDispose<CalendarNotifier, CalendarState>((ref) {
  return CalendarNotifier();
});

class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier()
      : super(
          CalendarState(
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
          ),
        );

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    Set<DateTime> bagDays = state.selectedDays;
    if (bagDays.contains(selectedDay)) {
      bagDays.remove(selectedDay);
    } else {
      bagDays.add(selectedDay);
    }

    if (!isSameDay(state.selectedDay, selectedDay)) {
      state = state.copyWith(
        selectedDays: bagDays,
        focusedDay: ValueNotifier(focusedDay),
        rangeStart: null,
        rangeEnd: null,
        rangeSelectionMode: RangeSelectionMode.toggledOff,
        selectedEvents: ValueNotifier(getEventsForDay(selectedDay)),
      );
    }
  }

  List<Event> getEventsForDay(DateTime day) {
    return state.kEvents?[day] ?? [];
  }

  List<Event> getEventsForRange(DateTime start, DateTime end) {
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
    List<Event> eventsBag = [];

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
      selectedEvents: ValueNotifier(getEventsForDay(DateTime.now())),
    );
  }

  bool canClearSelection() {
    return state.selectedDays.isNotEmpty ||
        state.rangeStart != null ||
        state.rangeEnd != null;
  }
}

class CalendarState {
  final DateTime selectedDay;
  final ValueNotifier<DateTime> focusedDay;
  final ValueNotifier<List<Event>>? selectedEvents;
  final LinkedHashMap<DateTime, List<Event>>? kEvents;
  final CalendarFormat calendarFormat;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final RangeSelectionMode rangeSelectionMode;
  final DateTime kToday;
  final DateTime kFirstDay;
  final DateTime kLastDay;
  final Set<DateTime> selectedDays;

  CalendarState({
    required this.selectedDay,
    required this.focusedDay,
    this.selectedEvents,
    this.kEvents,
    this.calendarFormat = CalendarFormat.week,
    this.rangeStart,
    this.rangeEnd,
    this.rangeSelectionMode = RangeSelectionMode.toggledOff,
    required this.kToday,
    required this.kFirstDay,
    required this.kLastDay,
    required this.selectedDays,
  });

  DateTime newMethod() => DateTime.now();

  CalendarState copyWith({
    DateTime? selectedDay,
    ValueNotifier<DateTime>? focusedDay,
    ValueNotifier<List<Event>>? selectedEvents,
    LinkedHashMap<DateTime, List<Event>>? kEvents,
    CalendarFormat? calendarFormat,
    DateTime? rangeStart,
    DateTime? rangeEnd,
    RangeSelectionMode? rangeSelectionMode,
    DateTime? kToday,
    DateTime? kFirstDay,
    DateTime? kLastDay,
    Set<DateTime>? selectedDays,
  }) =>
      CalendarState(
        selectedDay: selectedDay ?? this.selectedDay,
        focusedDay: focusedDay ?? this.focusedDay,
        selectedEvents: selectedEvents ?? this.selectedEvents,
        kEvents: kEvents ?? this.kEvents,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
        rangeSelectionMode: rangeSelectionMode ?? this.rangeSelectionMode,
        kToday: kToday ?? this.kToday,
        kFirstDay: kFirstDay ?? this.kFirstDay,
        kLastDay: kLastDay ?? this.kLastDay,
        calendarFormat: calendarFormat ?? this.calendarFormat,
        selectedDays: selectedDays ?? this.selectedDays,
      );
}

int _getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
