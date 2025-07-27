import 'package:hr_tcc/domain/entities/requests/requests.dart';

class Request {
  final String id;
  final RequestType type;
  final DateTime createdAt;
  final RequestStatus status;

  Request({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.status,
  });
}
