import '../entities/pass_request.dart';
import '../repositories/pass_request_repository.dart';

class GetPassRequestByIdUseCase {
  final PassRequestRepository repository;
  GetPassRequestByIdUseCase(this.repository);

  Future<PassRequest?> call(String id) => repository.getById(id);
}
