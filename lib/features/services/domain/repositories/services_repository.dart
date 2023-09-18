import 'package:cars_app/features/services/domain/domain.dart';

abstract class ServicesRepository {
  Future<List<Service>> getServicesByPage({int limit = 10, int offset = 0});
  Future<Service> getServiceById(int id);
  Future<Service> createUpdateServices(Map<String, dynamic> serviceLike);
  Future<Map<String, dynamic>> deleteService(int id);
}
