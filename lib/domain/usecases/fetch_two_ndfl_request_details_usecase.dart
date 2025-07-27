import 'package:hr_tcc/domain/models/requests/two_ndfl_request_models.dart';
import 'package:hr_tcc/domain/repositories/two_ndfl_repository.dart';

class FetchTwoNdflRequestDetailsUseCase {
  final TwoNdflRepository repository;
  FetchTwoNdflRequestDetailsUseCase(this.repository);

  Future<TwoNdflRequestDetails> call(String id) {
    return repository.fetchDetails(id);
  }
}
