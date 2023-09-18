import 'package:cars_app/features/schedules/domain/domain.dart';

class SchedulesRepositoryImpl extends SchedulesRepository {
  final SchedulesRepository datasource;

  SchedulesRepositoryImpl({required this.datasource});

  @override
  Future<Schedule> createUpdateSchedules(Map<String, dynamic> serviceLike) {
    return datasource.createUpdateSchedules(serviceLike);
  }

  @override
  Future<Map<String, dynamic>> deleteSchedule(int id) {
    return datasource.deleteSchedule(id);
  }

  @override
  Future<Schedule> getScheduleById(int id) {
    return datasource.getScheduleById(id);
  }

  @override
  Future<List<Schedule>> getSchedulesByPage({int limit = 10, int offset = 0}) {
    return datasource.getSchedulesByPage(limit: limit, offset: offset);
  }
}
