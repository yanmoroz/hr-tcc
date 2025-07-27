import 'package:hr_tcc/domain/entities/requests/request_status.dart';

enum ReferralVacancy {
  aqaEngineerMobile('AQA инженер (mobile)'),
  itSalesSpecialist('IT Sales Specialist'),
  b2bSalesManager('Менеджер по активным продажам B2B'),
  itServiceHead('Руководитель IT-службы'),
  itDepartmentHead('Руководитель it-отдела'),
  itDirectionHead(
    'Руководитель IT-направления / Ведущий системный администратор',
  );

  final String label;
  const ReferralVacancy(this.label);
}

enum ReferralProgramRequestField {
  vacancy,
  candidateName,
  resumeLink,
  file,
  comment,
}

class ReferralProgramRequest {
  final String id;
  final ReferralVacancy vacancy;
  final String candidateName;
  final String resumeLink;
  final String? comment;
  final ReferralResumeFile? file;
  final DateTime createdAt;
  final bool isCompleted;
  final RequestStatus status;

  ReferralProgramRequest({
    required this.id,
    required this.vacancy,
    required this.candidateName,
    required this.resumeLink,
    this.comment,
    this.file,
    required this.createdAt,
    this.isCompleted = false,
    this.status = RequestStatus.active,
  });
}

class ReferralResumeFile {
  final String name;
  final int size;
  final String url;
  final String extension;

  ReferralResumeFile({
    required this.name,
    required this.size,
    required this.url,
    required this.extension,
  });
}
