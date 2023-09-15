import 'package:cars_app/features/vehicles/vehicles.dart';

class VehicleMapper {
  static jsonToEntity(Map<String, dynamic> json) => Vehicle(
        id: json['id'],
        name: json['name'],
        manufacturer: json['manufacturer'] ?? '',
        model: json['model'] ?? '',
        fuel: json['fuel'],
        type: json['type'] ?? '',
        color: json['color'] ?? '',
        mileage: json['mileage'],
        plate: json['plate'],
        customerId: json['customerId'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );
}
