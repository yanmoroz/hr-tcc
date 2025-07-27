import 'work_certificate_request_repository.dart';
import '../models/requests/work_certificate_request_models.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';

class WorkCertificateRequestRepositoryMock
    implements WorkCertificateRequestRepository {
  @override
  Future<WorkCertificateRequest> fetchRequestDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return WorkCertificateRequest(
      id: id,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: RequestStatus.completed,
      purpose: WorkCertificatePurpose.income,
      receiveDate: DateTime.now().add(const Duration(days: 5)),
      copiesCount: 2,
    );
  }

  @override
  Future<void> createRequest(WorkCertificateRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
