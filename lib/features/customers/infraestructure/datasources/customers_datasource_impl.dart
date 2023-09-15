import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/customers/domain/domain.dart';
import 'package:cars_app/features/customers/infraestructure/infraestructure.dart';
import 'package:cars_app/features/people/people.dart';
import 'package:dio/dio.dart';

class CustomersDatasourceImpl extends CustomersDatasource {
  late final Dio dio;
  final String accessToken;

  CustomersDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

  @override
  Future<People> createUpdateCustomer(Map<String, dynamic> peopleLike) async {
    try {
      final int? customerId = peopleLike['id'];
      final String method = (customerId == null) ? 'POST' : 'PATCH';
      peopleLike.remove('id');
      final String url =
          (customerId == null) ? '/customers/' : '/customers/$customerId';
      if (customerId == null) {
        peopleLike['password'] = peopleLike['document'] == 0
            ? Environment.standartPassword
            : '${peopleLike['document']}';
      }
      final response = await dio.request(
        url,
        data: peopleLike,
        options: Options(
          method: method,
        ),
      );

      final customer = PeopleMapper.jsonToEntity(response.data);
      return customer;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<People> getCustomerByDocument(int doc) {
    // TODO: implement getCustomerByDocument
    throw UnimplementedError();
  }

  @override
  Future<People> getCustomerById(int id) async {
    try {
      final response = await dio.get('/customers/$id');
      final customer = PeopleMapper.jsonToEntity(response.data);
      return customer;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw CustomerNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<People>> getCustomersByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/customers?limit=$limit&offset=$offset');
    final List<People> customers = [];

    for (var customer in response.data ?? []) {
      customers.add(PeopleMapper.jsonToEntity(customer));
    }

    return customers;
  }
}
