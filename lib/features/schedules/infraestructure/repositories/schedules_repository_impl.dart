import 'package:cars_app/features/schedules/domain/domain.dart';

class SchedulesRepositoryImpl extends SchedulesRepository {
  final SchedulesDatasource datasource;

  SchedulesRepositoryImpl({required this.datasource});

  @override
  Future<Schedule> createUpdateSchedules(Map<String, dynamic> scheduleLike) {
    return datasource.createUpdateSchedules(scheduleLike);
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
  Future<List<Schedule>> getSchedulesByDay(String day) {
    return datasource.getSchedulesByDay(day);
  }

  @override
  Future<List<Schedule>> getSchedulesByWeek(int weekNumber) {
    return datasource.getSchedulesByWeek(weekNumber);
  }

  @override
  Future<List<String>> getOccupiedTimes(DateTime date, int id) {
    return datasource.getOccupiedTimes(date, id);
  }
}
