import 'package:hr_tcc/presentation/widgets/common/app_file_grid/app_file_grid.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';

class ViolationRequest {
  final String id;
  final bool isConfidential;
  final String subject;
  final String description;
  final List<AppFileGridItem> files;
  final RequestStatus status;
  final DateTime createdAt;

  ViolationRequest({
    required this.id,
    required this.isConfidential,
    required this.subject,
    required this.description,
    required this.files,
    required this.status,
    required this.createdAt,
  });
}
