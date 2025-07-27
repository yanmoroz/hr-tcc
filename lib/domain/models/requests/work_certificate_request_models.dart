import 'package:hr_tcc/domain/entities/requests/request_status.dart';

enum WorkCertificatePurpose {
  income,
  mortgage,
  rent,
  newJob,
  visa,
  refinancing,
}

extension WorkCertificatePurposeExtension on WorkCertificatePurpose {
  String get label {
    switch (this) {
      case WorkCertificatePurpose.income:
        return 'Для подтверждения дохода';
      case WorkCertificatePurpose.mortgage:
        return 'Для ипотеки';
      case WorkCertificatePurpose.rent:
        return 'Для аренды';
      case WorkCertificatePurpose.newJob:
        return 'Для новой работы';
      case WorkCertificatePurpose.visa:
        return 'Для визы';
      case WorkCertificatePurpose.refinancing:
        return 'Для рефинансирования';
    }
  }
}

class WorkCertificateRequest {
  final String id;
  final DateTime createdAt;
  final RequestStatus status;
  final WorkCertificatePurpose purpose;
  final DateTime receiveDate;
  final int copiesCount;

  WorkCertificateRequest({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.purpose,
    required this.receiveDate,
    required this.copiesCount,
  });
}
