import 'package:hr_tcc/domain/entities/requests/request_status.dart';

enum AlpinaDigitalAccessRequestField {
  date,
  wasAccessProvided,
  addComment,
  comment,
  // скрытые поля:
  fio,
  department,
  position,
  email,
  phoneMobile,
  phoneWork,
  checkbox,
}

class AlpinaDigitalAccessRequest {
  final String id;
  final String fio;
  final String email;
  final String department;
  final String position;
  final String accessLevel;
  final String justification;
  final DateTime createdAt;
  final RequestStatus status;
  final DateTime date;
  final bool wasAccessProvided;
  final String? comment;
  final bool isChecked;

  AlpinaDigitalAccessRequest({
    required this.id,
    required this.fio,
    required this.email,
    required this.department,
    required this.position,
    required this.accessLevel,
    required this.justification,
    required this.createdAt,
    required this.status,
    required this.date,
    required this.wasAccessProvided,
    this.comment,
    required this.isChecked,
  });
}
