import 'package:cars_app/features/dashboard/domain/domain.dart';
import 'package:cars_app/features/schedules/domain/entities/schedule_entity.dart';
import 'package:cars_app/features/services/domain/entities/service_entity.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDatasource datasource;

  DashboardRepositoryImpl({required this.datasource});

  @override
  Future<Schedule?> getComingSchedule(int userId) {
    return datasource.getComingSchedule(userId);
  }

  @override
  Future<Service?> getComingService(int userId) {
    return datasource.getComingService(userId);
  }

  @override
  Future<List<Service>> getHistory(
      {int userId = 0, int limit = 10, int offset = 0}) {
    return datasource.getHistory(userId: userId, limit: limit, offset: offset);
  }

  @override
  Future<Service> updateComingService(Map<String, dynamic> data) {
    return datasource.updateComingService(data);
  }

  @override
  Future<Schedule> updateComingSchedule(Map<String, dynamic> data) {
    return datasource.updateComingSchedule(data);
  }

  @override
  Future<dynamic> getGeneralReport() {
    return datasource.getGeneralReport();
  }

  @override
  Future<dynamic> dowloadReport(String url, String path) {
    return datasource.dowloadReport(url, path);
  }
}
