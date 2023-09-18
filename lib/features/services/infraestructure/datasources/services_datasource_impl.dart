import 'package:cars_app/features/services/domain/domain.dart';

class ServicesDatasourceImpl extends ServicesDatasource {
  @override
  Future<Service> createUpdateServices(Map<String, dynamic> serviceLike) {
    // TODO: implement createUpdateServices
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> deleteService(int id) {
    // TODO: implement deleteService
    throw UnimplementedError();
  }

  @override
  Future<Service> getServiceById(int id) {
    // TODO: implement getServiceById
    throw UnimplementedError();
  }

  @override
  Future<List<Service>> getServicesByPage({int limit = 10, int offset = 0}) {
    // TODO: implement getServicesByPage
    throw UnimplementedError();
  }
}
