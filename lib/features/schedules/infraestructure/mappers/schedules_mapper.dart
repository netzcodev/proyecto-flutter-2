import 'package:cars_app/features/schedules/domain/domain.dart';
import 'package:cars_app/features/services/services.dart';
import 'package:flutter/material.dart';

class SchedulesMapper {
  static jsonToEntity(Map<String, dynamic> json) => Schedule(
        id: json['id'],
        customerId: json['customerId'],
        employeeId: json['employeeId'],
        date: json['date'],
        time: TimeOfDay(
          hour: int.parse(json['time'].split(':')[0]),
          minute: int.parse(json['time'].split(':')[1]),
        ),
        name: json['name'],
        description: json['description'],
        services:
            json['services'] == null || List.from(json['services']).isEmpty
                ? []
                : ServiceMapper.jsonToListEntity(json['services']),
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );
}
