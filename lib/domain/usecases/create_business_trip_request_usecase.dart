import '../entities/requests/business_trip_request.dart';
import '../repositories/business_trip_request_repository.dart';

class CreateBusinessTripRequestUseCase {
  final BusinessTripRequestRepository repository;
  CreateBusinessTripRequestUseCase(this.repository);

  Future<void> call(BusinessTripRequest request) {
    return repository.create(request);
  }
}
