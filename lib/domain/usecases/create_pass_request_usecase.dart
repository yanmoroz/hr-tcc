import '../entities/pass_request.dart';
import '../repositories/pass_request_repository.dart';

class CreatePassRequestUseCase {
  final PassRequestRepository repository;
  CreatePassRequestUseCase(this.repository);

  Future<void> call(PassRequest request) => repository.create(request);
}
