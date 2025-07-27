import 'package:hr_tcc/domain/models/logout_result.dart';

class LogoutResultDto {
  final String message;

  LogoutResultDto({required this.message});

  factory LogoutResultDto.fromJson(Map<String, dynamic> json) {
    return LogoutResultDto(message: json['message']);
  }

  // Mapper to domain model
  LogoutResult toDomain() {
    return LogoutResult(message: message);
  }
}
