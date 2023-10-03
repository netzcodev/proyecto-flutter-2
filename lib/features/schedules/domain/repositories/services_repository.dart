import 'package:cars_app/features/schedules/domain/domain.dart';

abstract class SchedulesRepository {
  Future<List<Schedule>> getSchedulesByDay(String day);
  Future<List<Schedule>> getSchedulesByWeek(int weekNumber);
  Future<Schedule> getScheduleById(int id);
  Future<Schedule> createUpdateSchedules(Map<String, dynamic> scheduleLike);
  Future<Map<String, dynamic>> deleteSchedule(int id);
  Future<List<String>> getOccupiedTimes(DateTime date, int id);
}
