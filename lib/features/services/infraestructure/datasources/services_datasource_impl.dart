import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/services/domain/domain.dart';
import 'package:cars_app/features/services/infraestructure/infraestructure.dart';
import 'package:dio/dio.dart';

class ServicesDatasourceImpl extends ServicesDatasource {
  late final Dio dio;
  final String accessToken;

  ServicesDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(BaseOptions(baseUrl: Environment.apiUrl, headers: {
          'Authorization': 'Bearer $accessToken',
        }));

  @override
  Future<Service> createUpdateServices(Map<String, dynamic> serviceLike) async {
    try {
      final int? serviceId = serviceLike['id'];
      final String method = (serviceId == null) ? 'POST' : 'PATCH';
      serviceLike.remove('id');
      final String url =
          (serviceId == null) ? '/services/' : '/services/$serviceId';

      final response = await dio.request(
        url,
        data: serviceLike,
        options: Options(
          method: method,
        ),
      );

      final service = ServiceMapper.jsonToEntity(response.data);
      return service;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, dynamic>> deleteService(int id) {
    // TODO: implement deleteService
    throw UnimplementedError();
  }

  @override
  Future<Service> getServiceById(int id) async {
    try {
      final response = await dio.get('/services/$id');
      final service = ServiceMapper.jsonToEntity(response.data);
      return service;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ServiceNotFound();
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Service>> getServicesByPage(
      {int limit = 10, int offset = 0, int scheduleId = 0}) async {
    final response = await dio.get<List>(
        '/services?limit=$limit&offset=$offset&schedule=$scheduleId');
    final List<Service> services = [];

    for (var service in response.data ?? []) {
      services.add(ServiceMapper.jsonToEntity(service));
    }

    return services;
  }
}
