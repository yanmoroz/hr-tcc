import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/domain/repositories/unplanned_training_request_repository.dart';

class GetUnplannedTrainingRequestUseCase {
  final UnplannedTrainingRequestRepository repository;
  GetUnplannedTrainingRequestUseCase(this.repository);

  Future<UnplannedTrainingRequest?> call(String id) async {
    final all = await repository.fetchRequests();
    try {
      return all.firstWhere((r) => r.id == id);
    } on Exception catch (_) {
      return null;
    }
  }
}
