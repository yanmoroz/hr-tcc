import 'package:hr_tcc/domain/entities/requests/referral_program_request.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:hr_tcc/domain/repositories/referral_program_request_repository.dart';

class ReferralProgramRequestRepositoryMock
    implements ReferralProgramRequestRepository {
  final List<ReferralProgramRequest> _requests = [];

  @override
  Future<void> createReferralRequest(ReferralProgramRequest request) async {
    _requests.add(request);
  }

  @override
  Future<List<ReferralProgramRequest>> getReferralRequests() async {
    return List.unmodifiable(_requests);
  }

  @override
  Future<ReferralProgramRequest?> getReferralRequestById(String id) async {
    try {
      return _requests.firstWhere((r) => r.id == id);
    } on Exception catch (_) {
      return ReferralProgramRequest(
        id: id,
        vacancy: ReferralVacancy.aqaEngineerMobile,
        candidateName: 'Иванов Иван Иванович',
        resumeLink: 'https://hh.ru/resume/123456',
        file: ReferralResumeFile(
          name: 'resume.pdf',
          size: 1024 * 1024,
          url: '',
          extension: 'pdf',
        ),
        comment: 'Комментарий к заявке',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: RequestStatus.approved,
      );
    }
  }

  @override
  Future<List<ReferralVacancy>> getVacancies() async {
    return [
      ReferralVacancy.aqaEngineerMobile,
      ReferralVacancy.itSalesSpecialist,
      ReferralVacancy.b2bSalesManager,
      ReferralVacancy.itServiceHead,
      ReferralVacancy.itDepartmentHead,
      ReferralVacancy.itDirectionHead,
    ];
  }
}
