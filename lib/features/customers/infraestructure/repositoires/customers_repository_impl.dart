import 'package:cars_app/features/customers/domain/domain.dart';
import 'package:cars_app/features/people/people.dart';

class CustomersRepositoryImpl extends CustomersRepository {
  final CustomersDatasource datasource;

  CustomersRepositoryImpl({required this.datasource});

  @override
  Future<People> createUpdateCustomer(Map<String, dynamic> peopleLike) {
    return datasource.createUpdateCustomer(peopleLike);
  }

  @override
  Future<People> getCustomerByDocument(int doc) {
    return datasource.getCustomerByDocument(doc);
  }

  @override
  Future<People> getCustomerById(int id) {
    return datasource.getCustomerById(id);
  }

  @override
  Future<List<People>> getCustomersByPage({int limit = 10, int offset = 0}) {
    return datasource.getCustomersByPage(limit: limit, offset: offset);
  }
}
