import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/vehicles/domain/domain.dart';
import 'package:cars_app/features/vehicles/infraestructure/infraestructure.dart';
import 'package:dio/dio.dart';

class VehiclesDatasourceImpl extends VehiclesDatasource {
  late final Dio dio;
  final String accessToken;

  VehiclesDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(BaseOptions(baseUrl: Environment.apiUrl, headers: {
          'Authorization': 'Bearer $accessToken',
        }));

  @override
  Future<Vehicle> createUpdateVehicles(Map<String, dynamic> vehicleLike) async {
    try {
      final int? vehicleId = vehicleLike['id'];
      final String method = (vehicleId == null) ? 'POST' : 'PATCH';
      vehicleLike.remove('id');
      final String url =
          (vehicleId == null) ? '/vehicles/' : '/vehicles/$vehicleId';

      final response = await dio.request(
        url,
        data: vehicleLike,
        options: Options(
          method: method,
        ),
      );

      final vehicle = VehicleMapper.jsonToEntity(response.data);
      return vehicle;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Vehicle> getVehicleById(int id) async {
    try {
      final response = await dio.get('/vehicles/$id');
      final vehicle = VehicleMapper.jsonToEntity(response.data);
      return vehicle;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw VehicleNotFound();
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Vehicle> getVehicleByPlate(String plate) {
    // TODO: implement getVehicleByPlate
    throw UnimplementedError();
  }

  @override
  Future<List<Vehicle>> getVehiclesByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/vehicles?limit=$limit&offset=$offset');
    final List<Vehicle> vehicles = [];

    for (var vehicle in response.data ?? []) {
      vehicles.add(VehicleMapper.jsonToEntity(vehicle));
    }

    return vehicles;
  }

  @override
  Future<Map<String, dynamic>> deleteVehicle(int id) async {
    try {
      final response = await dio.delete('/vehicles/$id');
      final deletedVehicle = response.data;
      return deletedVehicle;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw VehicleNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
