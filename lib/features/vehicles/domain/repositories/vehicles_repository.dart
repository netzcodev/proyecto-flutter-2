import 'package:cars_app/features/vehicles/domain/domain.dart';

abstract class VehiclesRepository {
  Future<List<Vehicle>> getVehiclesByPage({int limit = 10, int offset = 0});
  Future<Vehicle> getVehicleByPlate(String plate);
  Future<Vehicle> getVehicleById(int id);
  Future<Vehicle> createUpdateVehicles(Map<String, dynamic> vehicleLike);
  Future<Map<String, dynamic>> deleteVehicle(int id);
}
