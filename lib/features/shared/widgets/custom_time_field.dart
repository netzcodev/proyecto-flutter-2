import 'package:flutter/material.dart';

class CustomTimeSegmentedControl extends StatefulWidget {
  final List<String> occupiedTimes;
  final String? errorMessage;
  final Function(TimeOfDay)? onTimeSelected;
  final TimeOfDay? selected;

  const CustomTimeSegmentedControl({
    super.key,
    required this.occupiedTimes,
    this.errorMessage,
    this.onTimeSelected,
    this.selected,
  });

  @override
  State<CustomTimeSegmentedControl> createState() =>
      _CustomTimeSegmentedControlState();
}

class _CustomTimeSegmentedControlState
    extends State<CustomTimeSegmentedControl> {
  String? _selectedTime;
  final List<String> availableTimes = [
    '8:00 AM',
    '10:00 AM',
    '12:00 PM',
    '2:00 PM',
    '4:00 PM',
  ];

  TimeOfDay _stringToTimeOfDay(String time) {
    final split = time.split(' ');
    final hourSplit = split[0].split(':');
    final hour = int.parse(hourSplit[0]);
    final period = split[1];

    if (period == "PM" && hour != 12) {
      return TimeOfDay(hour: hour + 12, minute: 0);
    } else {
      return TimeOfDay(hour: hour, minute: 0);
    }
  }

  String _timeOfDayToString(TimeOfDay time) {
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  void initState() {
    super.initState();
    _selectedTime = _timeOfDayToString(widget.selected!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SegmentedButton(
          multiSelectionEnabled: false,
          showSelectedIcon: false,
          segments: availableTimes.map((time) {
            bool isOccupied = widget.occupiedTimes.contains(time);
            return ButtonSegment(
              enabled: !isOccupied,
              value: time,
              label: Text(
                time,
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          selected: {_selectedTime},
          onSelectionChanged: (newSelection) {
            FocusScope.of(context).unfocus();
            setState(() {
              _selectedTime = newSelection.first as String;
            });
            if (widget.onTimeSelected != null) {
              widget.onTimeSelected!(_stringToTimeOfDay(_selectedTime!));
            }
          },
        ),
        if (widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          )
      ],
    );
  }
}
