import '../entities/parking_request.dart';
import '../repositories/parking_request_repository.dart';

class GetParkingRequestByIdUseCase {
  final ParkingRequestRepository repository;
  GetParkingRequestByIdUseCase(this.repository);

  Future<ParkingRequest?> call(String id) => repository.getById(id);
}
