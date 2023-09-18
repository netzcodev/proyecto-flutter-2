import 'package:cars_app/features/employees/domain/domain.dart';

class EmployeesRepositoryImpl extends EmployeesRepository {
  final EmployeesRepository datasource;

  EmployeesRepositoryImpl({required this.datasource});

  @override
  Future<Employee> createUpdateEmployees(Map<String, dynamic> serviceLike) {
    return datasource.createUpdateEmployees(serviceLike);
  }

  @override
  Future<Map<String, dynamic>> deleteEmployee(int id) {
    return datasource.deleteEmployee(id);
  }

  @override
  Future<Employee> getEmployeeById(int id) {
    return datasource.getEmployeeById(id);
  }

  @override
  Future<List<Employee>> getEmployeesByPage({int limit = 10, int offset = 0}) {
    return datasource.getEmployeesByPage(limit: limit, offset: offset);
  }
}
