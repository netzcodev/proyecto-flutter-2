class Vehicle {
  final int? id;
  final String name;
  final String manufacturer;
  final String model;
  final String fuel;
  final String type;
  final String color;
  final int mileage;
  final String vId;
  final String plate;
  final int owner;
  final String? createdAt;
  final String? updatedAt;

  Vehicle({
    this.id,
    required this.name,
    required this.manufacturer,
    required this.model,
    required this.fuel,
    required this.type,
    required this.color,
    required this.mileage,
    required this.vId,
    required this.plate,
    required this.owner,
    this.createdAt,
    this.updatedAt,
  });
}
