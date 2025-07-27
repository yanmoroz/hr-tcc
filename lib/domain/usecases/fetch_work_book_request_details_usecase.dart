import 'package:hr_tcc/domain/models/requests/work_book_request_models.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class FetchWorkBookRequestDetailsUseCase {
  final WorkBookRepository repository;
  FetchWorkBookRequestDetailsUseCase(this.repository);

  Future<WorkBookRequestDetails> call(String id) {
    return repository.fetchRequestDetails(id);
  }
}
