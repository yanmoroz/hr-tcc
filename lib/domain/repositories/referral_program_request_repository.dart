import '../entities/requests/referral_program_request.dart';

abstract class ReferralProgramRequestRepository {
  Future<void> createReferralRequest(ReferralProgramRequest request);
  Future<List<ReferralProgramRequest>> getReferralRequests();
  Future<ReferralProgramRequest?> getReferralRequestById(String id);
  Future<List<ReferralVacancy>> getVacancies();
}
