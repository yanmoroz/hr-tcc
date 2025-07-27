import 'package:hr_tcc/domain/entities/violation_request.dart';

abstract class ViolationRequestRepository {
  Future<void> submit(ViolationRequest request);
  Future<ViolationRequest> getById(String id);
}
