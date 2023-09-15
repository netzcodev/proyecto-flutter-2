import 'package:cars_app/features/people/people.dart';

abstract class CustomersDatasource {
  Future<List<People>> getCustomersByPage({int limit = 10, int offset = 0});
  Future<People> getCustomerById(int id);
  Future<People> getCustomerByDocument(int doc);
  Future<People> createUpdateCustomer(Map<String, dynamic> peopleLike);
}
