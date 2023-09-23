class Service {
  final int? id;
  final String name;
  final String description;
  final int serviceTypeId;
  final String currentDate;
  final String comingDate;
  final int duration;
  final int? scheduleId;
  final String? createdAt;
  final String? updatedAt;

  Service({
    this.id,
    this.scheduleId,
    required this.serviceTypeId,
    required this.currentDate,
    required this.comingDate,
    required this.duration,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });
}
