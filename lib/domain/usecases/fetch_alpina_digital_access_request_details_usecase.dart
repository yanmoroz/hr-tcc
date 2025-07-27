import '../repositories/alpina_digital_access_request_repository.dart';
import '../models/requests/alpina_digital_access_request_models.dart';

class FetchAlpinaDigitalAccessRequestDetailsUseCase {
  final AlpinaDigitalAccessRequestRepository repository;
  FetchAlpinaDigitalAccessRequestDetailsUseCase(this.repository);

  Future<AlpinaDigitalAccessRequest> call(String id) {
    return repository.fetchRequestDetails(id);
  }
}
