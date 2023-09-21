import 'package:flutter/material.dart';

class Schedule {
  final int? id;
  final int customerId;
  final int employeeId;
  final int? serviceId;
  final String date;
  final TimeOfDay time;
  final String name;
  final String description;
  final String? createdAt;
  final String? updatedAt;

  Schedule({
    this.id,
    required this.customerId,
    required this.employeeId,
    required this.name,
    required this.description,
    this.serviceId,
    required this.date,
    required this.time,
    this.createdAt,
    this.updatedAt,
  });
}
