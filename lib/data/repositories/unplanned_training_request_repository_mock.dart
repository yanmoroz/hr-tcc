import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/domain/repositories/unplanned_training_request_repository.dart';

class UnplannedTrainingRequestRepositoryMock
    implements UnplannedTrainingRequestRepository {
  final List<UnplannedTrainingRequest> _requests = [];

  @override
  Future<void> createRequest(UnplannedTrainingRequest request) async {
    _requests.add(request);
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<List<UnplannedTrainingRequest>> fetchRequests() async {
    return _requests;
  }
}
