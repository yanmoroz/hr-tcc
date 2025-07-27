import 'package:hr_tcc/domain/entities/entities.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class FetchRequestsUseCase {
  final RequestsRepository repository;
  FetchRequestsUseCase(this.repository);

  Future<List<Request>> call({
    int page = 1,
    int pageSize = 10,
    RequestStatus? status,
    String? query,
  }) {
    return repository.fetchRequests(
      page: page,
      pageSize: pageSize,
      status: status,
      query: query,
    );
  }
}
