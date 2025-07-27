import '../entities/parking_request.dart';
import '../repositories/parking_request_repository.dart';

class CreateParkingRequestUseCase {
  final ParkingRequestRepository repository;
  CreateParkingRequestUseCase(this.repository);

  Future<void> call(ParkingRequest request) => repository.create(request);
}
