import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';

abstract class UnplannedTrainingRequestRepository {
  Future<void> createRequest(UnplannedTrainingRequest request);
  Future<List<UnplannedTrainingRequest>> fetchRequests();
}
