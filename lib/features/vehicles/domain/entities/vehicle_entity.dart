class Vehicle {
  final int? id;
  final String name;
  final String manufacturer;
  final String model;
  final String fuel;
  final String type;
  final String color;
  final int mileage;
  final String plate;
  final int customerId;
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
    required this.plate,
    required this.customerId,
    this.createdAt,
    this.updatedAt,
  });
}
