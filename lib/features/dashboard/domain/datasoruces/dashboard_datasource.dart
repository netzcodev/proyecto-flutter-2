import 'package:cars_app/features/schedules/schedules.dart';
import 'package:cars_app/features/services/services.dart';

abstract class DashboardDatasource {
  Future<Service?> getComingService(int userId);
  Future<List<Service>> getHistory({int userId, int limit, int offset});
  Future<Schedule?> getComingSchedule(int userId);
}
