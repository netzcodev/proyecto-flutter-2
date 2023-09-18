import 'package:cars_app/features/people/domain/entities/people_entity.dart';

abstract class PeopleRepository {
  Future<List<People>> getPeopleByPage({int limit = 10, int offset = 0});
  Future<List<People>> getEmployeesByPage({int limit = 10, int offset = 0});
  Future<List<People>> getCustomersByPage({int limit = 10, int offset = 0});
  Future<People> getPeopleById(int id);
  Future<People> getPeopleByDocument(int doc);
  Future<People> createUpdatePeople(Map<String, dynamic> peopleLike);
  Future<Map<String, dynamic>> deletePeople(int id);
}
