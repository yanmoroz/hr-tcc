import '../models/requests/work_certificate_request_models.dart';

abstract class WorkCertificateRequestRepository {
  Future<WorkCertificateRequest> fetchRequestDetails(String id);
  Future<void> createRequest(WorkCertificateRequest request);
}
