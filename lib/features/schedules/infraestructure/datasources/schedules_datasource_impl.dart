import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/schedules/domain/domain.dart';
import 'package:cars_app/features/schedules/infraestructure/infraestructure.dart';
import 'package:dio/dio.dart';

class SchedulesDatasourceImpl extends SchedulesDatasource {
  late final Dio dio;
  final String accessToken;

  SchedulesDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

  @override
  Future<Schedule> createUpdateSchedules(
      Map<String, dynamic> scheduleLike) async {
    try {
      final int? scheduleId = scheduleLike['id'];
      final String method = (scheduleId == null) ? 'POST' : 'PATCH';
      scheduleLike.remove('id');
      final String url =
          (scheduleId == null) ? '/schedules/' : '/schedules/$scheduleId';

      final response = await dio.request(
        url,
        data: scheduleLike,
        options: Options(
          method: method,
        ),
      );

      final schedule = SchedulesMapper.jsonToEntity(response.data);
      return schedule;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, dynamic>> deleteSchedule(int id) async {
    try {
      final response = await dio.delete('/schedules/$id');
      final deletedSchedule = response.data;
      return deletedSchedule;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ScheduleNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Schedule> getScheduleById(int id) async {
    try {
      final response = await dio.get('/schedules/$id');
      final schedule = SchedulesMapper.jsonToEntity(response.data);
      return schedule;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ScheduleNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Schedule>> getSchedulesByDay(String day) async {
    final response = await dio.get<List>('/schedules?day=$day');
    final List<Schedule> events = [];

    for (var person in response.data ?? []) {
      events.add(SchedulesMapper.jsonToEntity(person));
    }

    return events;
  }

  @override
  Future<List<Schedule>> getSchedulesByWeek(int weekNumber) async {
    final response = await dio.get<List>('/schedules?week=$weekNumber');
    final List<Schedule> events = [];

    for (var person in response.data ?? []) {
      events.add(SchedulesMapper.jsonToEntity(person));
    }

    return events;
  }
}
