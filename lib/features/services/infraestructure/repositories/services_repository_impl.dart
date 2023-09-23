import 'package:cars_app/features/services/domain/domain.dart';

class ServicesRepositoryImpl extends ServicesRepository {
  final ServicesDatasource datasource;

  ServicesRepositoryImpl({required this.datasource});

  @override
  Future<Service> createUpdateServices(Map<String, dynamic> serviceLike) {
    return datasource.createUpdateServices(serviceLike);
  }

  @override
  Future<Map<String, dynamic>> deleteService(int id) {
    return datasource.deleteService(id);
  }

  @override
  Future<Service> getServiceById(int id) {
    return datasource.getServiceById(id);
  }

  @override
  Future<List<Service>> getServicesByPage(
      {int limit = 10, int offset = 0, int scheduleId = 0}) {
    return datasource.getServicesByPage(
        limit: limit, offset: offset, scheduleId: scheduleId);
  }
}
