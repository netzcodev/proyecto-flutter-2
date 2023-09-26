class Service {
  final int? id;
  final String name;
  final String description;
  final int serviceTypeId;
  final String currentDate;
  final String comingDate;
  final int duration;
  final int? scheduleId;
  final int vehicleId;
  final int mileage;
  final String? createdAt;
  final String? updatedAt;

  Service({
    this.id,
    this.scheduleId,
    required this.vehicleId,
    required this.serviceTypeId,
    required this.currentDate,
    required this.comingDate,
    required this.duration,
    required this.name,
    required this.description,
    required this.mileage,
    this.createdAt,
    this.updatedAt,
  });
}
