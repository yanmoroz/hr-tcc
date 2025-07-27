import 'package:hr_tcc/domain/models/requests/work_book_request_models.dart';

abstract class WorkBookRepository {
  Future<WorkBookRequestDetails> fetchRequestDetails(String id);
}
