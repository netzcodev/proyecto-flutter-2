import 'package:cars_app/features/schedules/schedules.dart';
import 'package:cars_app/features/services/services.dart';

abstract class DashboardRepository {
  Future<Service?> getComingService(int userId);
  Future<List<Service>> getHistory({int userId, int limit, int offset});
  Future<Schedule?> getComingSchedule(int userId);
  Future<Service> updateComingService(Map<String, dynamic> data);
  Future<Schedule> updateComingSchedule(Map<String, dynamic> data);
  Future<dynamic> getGeneralReport(int userId);
  Future<dynamic> dowloadReport(String url, String path);
}
