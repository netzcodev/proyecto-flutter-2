import 'package:cars_app/features/calendar/domain/entities/event_entity.dart';

abstract class CalendarDatasource {
  Future<List<Event>> getEvents();
}
