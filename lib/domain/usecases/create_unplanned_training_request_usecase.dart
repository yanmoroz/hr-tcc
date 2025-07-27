import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/domain/repositories/unplanned_training_request_repository.dart';

class CreateUnplannedTrainingRequestUseCase {
  final UnplannedTrainingRequestRepository repository;
  CreateUnplannedTrainingRequestUseCase(this.repository);

  Future<void> call(UnplannedTrainingRequest request) async {
    await repository.createRequest(request);
  }
}
