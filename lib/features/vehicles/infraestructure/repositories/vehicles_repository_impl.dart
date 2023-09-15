import 'package:cars_app/features/vehicles/domain/domain.dart';

class VehiclesRepositoryImpl extends VehiclesRepository {
  final VehiclesDatasource datasource;

  VehiclesRepositoryImpl({required this.datasource});

  @override
  Future<Vehicle> createUpdateVehicles(Map<String, dynamic> vehicleLike) {
    return datasource.createUpdateVehicles(vehicleLike);
  }

  @override
  Future<Vehicle> getVehicleById(int id) {
    return datasource.getVehicleById(id);
  }

  @override
  Future<Vehicle> getVehicleByPlate(String plate) {
    return datasource.getVehicleByPlate(plate);
  }

  @override
  Future<List<Vehicle>> getVehiclesByPage({int limit = 10, int offset = 0}) {
    return datasource.getVehiclesByPage(limit: limit, offset: offset);
  }

  @override
  Future<Map<String, dynamic>> deleteVehicle(int id) {
    return datasource.deleteVehicle(id);
  }
}
