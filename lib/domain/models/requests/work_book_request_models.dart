import 'package:hr_tcc/domain/entities/requests/request_status.dart';

enum WorkBookRequestField {
  copiesCount,
  receiveDate,
  isCertifiedCopy,
  isScanByEmail,
}

enum WorkBookPurpose { forRequirement, withIncome, forVisa, forOther }

extension WorkBookPurposeExtension on WorkBookPurpose {
  String get label {
    switch (this) {
      case WorkBookPurpose.forRequirement:
        return 'По месту требования';
      case WorkBookPurpose.withIncome:
        return 'По месту требования (с указанием дохода)';
      case WorkBookPurpose.forVisa:
        return 'Для визы';
      case WorkBookPurpose.forOther:
        return 'Другое';
    }
  }
}

class WorkBookRequestDetails {
  final String id;
  final DateTime createdAt;
  final RequestStatus status;
  final WorkBookPurpose purpose;
  final DateTime receiveDate;
  final bool isCertifiedCopy;
  final bool isScanByEmail;

  WorkBookRequestDetails({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.purpose,
    required this.receiveDate,
    required this.isCertifiedCopy,
    required this.isScanByEmail,
  });
}
