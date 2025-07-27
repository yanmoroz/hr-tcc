import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getEmployees();
}
