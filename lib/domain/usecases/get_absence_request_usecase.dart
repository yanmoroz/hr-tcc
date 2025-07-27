import 'package:hr_tcc/domain/entities/requests/absence_request.dart';
import 'package:hr_tcc/domain/repositories/absence_request_repository.dart';

class GetAbsenceRequestUseCase {
  final AbsenceRequestRepository repository;
  GetAbsenceRequestUseCase(this.repository);

  Future<AbsenceRequest> call(String id) {
    return repository.getAbsenceRequestById(id);
  }
}
