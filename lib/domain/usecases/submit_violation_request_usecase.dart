import 'package:hr_tcc/domain/entities/violation_request.dart';
import 'package:hr_tcc/domain/repositories/violation_request_repository.dart';

class SubmitViolationRequestUseCase {
  final ViolationRequestRepository repository;
  SubmitViolationRequestUseCase(this.repository);

  Future<void> call(ViolationRequest request) => repository.submit(request);
}
