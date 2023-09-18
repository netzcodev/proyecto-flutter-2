import 'package:cars_app/features/schedules/domain/domain.dart';

abstract class SchedulesDatasource {
  Future<List<Schedule>> getSchedulesByPage({int limit = 10, int offset = 0});
  Future<Schedule> getScheduleById(int id);
  Future<Schedule> createUpdateSchedules(Map<String, dynamic> serviceLike);
  Future<Map<String, dynamic>> deleteSchedule(int id);
}
