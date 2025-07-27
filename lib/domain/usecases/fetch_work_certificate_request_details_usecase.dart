import '../models/requests/work_certificate_request_models.dart';
import '../repositories/work_certificate_request_repository.dart';

class FetchWorkCertificateRequestDetailsUseCase {
  final WorkCertificateRequestRepository repository;
  FetchWorkCertificateRequestDetailsUseCase(this.repository);

  Future<WorkCertificateRequest> call(String id) {
    return repository.fetchRequestDetails(id);
  }
}
