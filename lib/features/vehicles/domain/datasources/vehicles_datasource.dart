import 'package:cars_app/features/vehicles/domain/domain.dart';

abstract class VehiclesDatasource {
  Future<List<Vehicle>> getVehiclesByPage({int limit = 10, int offset = 0});
  Future<Vehicle> getVehicleByPlate(String plate);
  Future<Vehicle> getVehicleById(int id);
  Future<Vehicle> createUpdateVehicles(Map<String, dynamic> vehicleLike);
}
