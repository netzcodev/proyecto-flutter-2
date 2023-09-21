import 'package:cars_app/features/schedules/domain/domain.dart';
import 'package:flutter/material.dart';

class SchedulesMapper {
  static jsonToEntity(Map<String, dynamic> json) => Schedule(
        customerId: json['customerId'],
        employeeId: json['employeeId'],
        date: json['date'],
        time: TimeOfDay(
          hour: int.parse(json['time'].split(':')[0]),
          minute: int.parse(json['time'].split(':')[1]),
        ),
        name: json['name'],
        description: json['description'],
      );
}
