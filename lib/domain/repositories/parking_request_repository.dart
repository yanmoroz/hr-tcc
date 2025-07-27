import '../entities/parking_request.dart';

abstract class ParkingRequestRepository {
  Future<List<ParkingRequest>> getAll();
  Future<ParkingRequest?> getById(String id);
  Future<void> create(ParkingRequest request);
}
