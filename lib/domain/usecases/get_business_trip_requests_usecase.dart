import '../entities/requests/business_trip_request.dart';
import '../repositories/business_trip_request_repository.dart';

class GetBusinessTripRequestsUseCase {
  final BusinessTripRequestRepository repository;
  GetBusinessTripRequestsUseCase(this.repository);

  Future<List<BusinessTripRequest>> call() {
    return repository.getAll();
  }
}
