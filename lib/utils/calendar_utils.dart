// import 'dart:collection';
// import 'package:cars_app/features/schedules/schedules.dart';
// import 'package:table_calendar/table_calendar.dart';

// /// Example event class.
// class Event {
//   final String title;

//   const Event(this.title);

//   @override
//   String toString() => title;
// }

// final kEvents = LinkedHashMap<DateTime, List<Schedule>>;

// final kEvents = LinkedHashMap<DateTime, List<Schedule>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// final _kEventSource = {
//   for (var item in List.generate(50, (index) => index))
//     DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
// }..addAll({
//     kToday: [
//       const Event('Today\'s Event 1'),
//       const Event('Today\'s Event 2'),
//     ],
//   });