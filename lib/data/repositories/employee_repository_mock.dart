import 'package:hr_tcc/domain/repositories/employee_repository.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

class EmployeeRepositoryMock implements EmployeeRepository {
  @override
  Future<List<Employee>> getEmployees() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      Employee(
        id: '1',
        fullName: 'Гребенников Владимир Александрович',
        role: 'Руководитель',
      ),
      Employee(id: '2', fullName: 'Климов Михаил Максимович', role: 'Менеджер'),
      Employee(id: '3', fullName: 'Иванова Мария Сергеевна', role: 'Инженер'),
      Employee(
        id: '4',
        fullName: 'Петров Алексей Дмитриевич',
        role: 'Бухгалтер',
      ),
    ];
  }
}
