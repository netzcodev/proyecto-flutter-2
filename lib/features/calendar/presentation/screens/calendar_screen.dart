import 'package:cars_app/features/calendar/domain/domail.dart';
import 'package:cars_app/features/calendar/presentation/providers/calendar_provider.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _CalendarView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Cita'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _CalendarView extends ConsumerWidget {
  const _CalendarView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _CalendarViewState();
  }
}

class _CalendarViewState extends ConsumerWidget {
  late final PageController _pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);
    final calendarNotifier = ref.watch(calendarProvider.notifier);

    return Column(
      children: [
        Column(
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: calendarState.focusedDay,
              builder: (context, value, widget) {
                return _CalendarHeader(
                  focusedDay: value,
                  clearButtonVisible: calendarNotifier.canClearSelection(),
                  onTodayButtonTap: () =>
                      calendarNotifier.onFocusedDayChange(DateTime.now()),
                  onClearButtonTap: () => calendarNotifier.resetState(),
                  onLeftArrowTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  onRightArrowTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                );
              },
            ),
          ],
        ),
        TableCalendar<Event>(
          firstDay: calendarState.kFirstDay,
          lastDay: calendarState.kLastDay,
          headerVisible: false,
          focusedDay: calendarState.focusedDay.value,
          onCalendarCreated: (pageController) =>
              _pageController = pageController,
          selectedDayPredicate: (day) =>
              calendarState.selectedDays.contains(day),
          enabledDayPredicate: (day) => day.weekday != 7,
          rangeStartDay: calendarState.rangeStart,
          rangeEndDay: calendarState.rangeEnd,
          calendarFormat: calendarState.calendarFormat,
          rangeSelectionMode: calendarState.rangeSelectionMode,
          eventLoader: calendarNotifier.getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
          ),
          onDaySelected: calendarNotifier.onDaySelected,
          onRangeSelected: calendarNotifier.onRangeSelected,
          onFormatChanged: calendarNotifier.onFormatChanged,
          onPageChanged: calendarNotifier.onFocusedDayChange,
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: calendarState.selectedEvents ??
                ValueNotifier(
                  calendarNotifier.getEventsForDay(
                    DateTime.now(),
                  ),
                ),
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${value[index]}'),
                      title: Text('${value[index]}'),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: const TextStyle(fontSize: 26.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: const Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
