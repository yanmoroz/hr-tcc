import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/domain/repositories/courier_request_repository.dart';

class FetchCourierRequestDataUseCase {
  final CourierRequestRepository repository;
  FetchCourierRequestDataUseCase(this.repository);

  Future<List<Office>> fetchOffices() => repository.fetchOffices();
  Future<List<Employee>> fetchEmployees() => repository.fetchEmployees();
  Future<List<TripGoal>> fetchTripGoals() => repository.fetchTripGoals();
}
