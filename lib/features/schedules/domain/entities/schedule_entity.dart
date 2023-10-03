import 'package:cars_app/features/services/services.dart';
import 'package:flutter/material.dart';

class Schedule {
  final int? id;
  final int customerId;
  final int employeeId;
  final List<Service> services;
  final String date;
  final TimeOfDay time;
  final String name;
  final String description;
  final List<String>? occupiedTimes;
  final String? createdAt;
  final String? updatedAt;

  Schedule({
    this.id,
    required this.customerId,
    required this.employeeId,
    required this.name,
    required this.description,
    required this.services,
    required this.date,
    required this.time,
    this.occupiedTimes,
    this.createdAt,
    this.updatedAt,
  });
}
