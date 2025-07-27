import 'package:hr_tcc/domain/entities/violation_request.dart';
import 'package:hr_tcc/domain/repositories/violation_request_repository.dart';

class GetViolationRequestUseCase {
  final ViolationRequestRepository repository;
  GetViolationRequestUseCase(this.repository);

  Future<ViolationRequest> call(String id) => repository.getById(id);
}
