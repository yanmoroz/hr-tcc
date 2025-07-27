import 'package:hr_tcc/domain/entities/requests/absence_request.dart';
import 'package:hr_tcc/domain/repositories/absence_request_repository.dart';

class CreateAbsenceRequestUseCase {
  final AbsenceRequestRepository repository;
  CreateAbsenceRequestUseCase(this.repository);

  Future<void> call(AbsenceRequest request) {
    return repository.createAbsenceRequest(request);
  }
}
