import '../../domain/entities/requests/referral_program_request.dart';
import '../../domain/repositories/referral_program_request_repository.dart';

class CreateReferralProgramRequestUseCase {
  final ReferralProgramRequestRepository repository;
  CreateReferralProgramRequestUseCase(this.repository);

  Future<void> call(ReferralProgramRequest request) {
    return repository.createReferralRequest(request);
  }
}
