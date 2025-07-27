import '../entities/pass_request.dart';

abstract class PassRequestRepository {
  Future<List<PassRequest>> getAll();
  Future<PassRequest?> getById(String id);
  Future<void> create(PassRequest request);
}
