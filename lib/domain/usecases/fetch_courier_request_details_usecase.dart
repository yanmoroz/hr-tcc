import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/domain/repositories/courier_request_repository.dart';

class FetchCourierRequestDetailsUseCase {
  final CourierRequestRepository repository;
  FetchCourierRequestDetailsUseCase(this.repository);

  Future<CourierRequestDetails> call(String id) {
    return repository.fetchCourierRequestDetails(id);
  }
}
