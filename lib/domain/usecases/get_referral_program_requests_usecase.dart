import '../../domain/entities/requests/referral_program_request.dart';
import '../../domain/repositories/referral_program_request_repository.dart';

class GetReferralProgramRequestsUseCase {
  final ReferralProgramRequestRepository repository;
  GetReferralProgramRequestsUseCase(this.repository);

  Future<List<ReferralProgramRequest>> call() {
    return repository.getReferralRequests();
  }
}
