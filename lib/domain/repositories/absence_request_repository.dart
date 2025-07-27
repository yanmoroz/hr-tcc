import 'package:hr_tcc/domain/entities/requests/absence_request.dart';

abstract class AbsenceRequestRepository {
  Future<void> createAbsenceRequest(AbsenceRequest request);
  Future<AbsenceRequest> getAbsenceRequestById(String id);
  Future<List<AbsenceRequest>> getAllAbsenceRequests();
}
