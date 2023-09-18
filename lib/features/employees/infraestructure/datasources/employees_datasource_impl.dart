import 'package:cars_app/features/employees/domain/domain.dart';

class EmployeesDatasourceImpl extends EmployeesDatasource {
  @override
  Future<Employee> createUpdateEmployees(Map<String, dynamic> serviceLike) {
    // TODO: implement createUpdateEmployees
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> deleteEmployee(int id) {
    // TODO: implement deleteEmployee
    throw UnimplementedError();
  }

  @override
  Future<Employee> getEmployeeById(int id) {
    // TODO: implement getEmployeeById
    throw UnimplementedError();
  }

  @override
  Future<List<Employee>> getEmployeesByPage({int limit = 10, int offset = 0}) {
    // TODO: implement getEmployeesByPage
    throw UnimplementedError();
  }
}
