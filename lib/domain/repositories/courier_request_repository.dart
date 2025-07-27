import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

abstract class CourierRequestRepository {
  Future<List<Office>> fetchOffices();
  Future<List<Employee>> fetchEmployees();
  Future<List<TripGoal>> fetchTripGoals();
  Future<CourierRequestDetails> fetchCourierRequestDetails(String id);
}
