import '../../domain/entities/requests/referral_program_request.dart';
import '../../domain/repositories/referral_program_request_repository.dart';

class GetReferralProgramRequestByIdUseCase {
  final ReferralProgramRequestRepository repository;
  GetReferralProgramRequestByIdUseCase(this.repository);

  Future<ReferralProgramRequest?> call(String id) {
    return repository.getReferralRequestById(id);
  }
}
