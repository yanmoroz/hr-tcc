import '../entities/requests/business_trip_request.dart';
import '../repositories/business_trip_request_repository.dart';

class GetBusinessTripRequestUseCase {
  final BusinessTripRequestRepository repository;
  GetBusinessTripRequestUseCase(this.repository);

  Future<BusinessTripRequest?> call(String id) {
    return repository.getById(id);
  }
}
