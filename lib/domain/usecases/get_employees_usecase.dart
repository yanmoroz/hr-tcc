import '../repositories/employee_repository.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

class GetEmployeesUseCase {
  final EmployeeRepository repository;
  GetEmployeesUseCase(this.repository);

  Future<List<Employee>> call() => repository.getEmployees();
}
