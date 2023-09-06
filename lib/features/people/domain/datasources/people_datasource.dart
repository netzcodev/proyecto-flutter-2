import 'package:cars_app/features/people/domain/entities/people_entity.dart';

abstract class PeopleDatasource {
  Future<List<People>> getPeopleByPage({int limit = 10, int offset = 0});
  Future<People> getPeopleById(int id);
  Future<People> getPeopleByDocument(int doc);
  Future<People> createUpdatePeople(Map<String, dynamic> peopleLike);
}
