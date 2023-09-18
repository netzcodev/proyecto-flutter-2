import 'package:cars_app/features/employees/domain/domain.dart';

abstract class EmployeesRepository {
  Future<List<Employee>> getEmployeesByPage({int limit = 10, int offset = 0});
  Future<Employee> getEmployeeById(int id);
  Future<Employee> createUpdateEmployees(Map<String, dynamic> serviceLike);
  Future<Map<String, dynamic>> deleteEmployee(int id);
}
