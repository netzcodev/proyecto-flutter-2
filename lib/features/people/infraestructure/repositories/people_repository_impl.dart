import 'package:cars_app/features/people/domain/domain.dart';

class PeopleRepositoryImpl extends PeopleRepository {
  final PeopleDatasource datasource;

  PeopleRepositoryImpl({required this.datasource});

  @override
  Future<People> createUpdatePeople(Map<String, dynamic> peopleLike) {
    return datasource.createUpdatePeople(peopleLike);
  }

  @override
  Future<People> getPeopleByDocument(int doc) {
    return datasource.getPeopleByDocument(doc);
  }

  @override
  Future<People> getPeopleById(int id) {
    return datasource.getPeopleById(id);
  }

  @override
  Future<List<People>> getPeopleByPage({int limit = 10, int offset = 0}) {
    return datasource.getPeopleByPage(limit: limit, offset: offset);
  }
}
