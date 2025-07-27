import '../../domain/entities/current_user.dart';
import '../../domain/models/auth_result.dart';

class AuthResultDto {
  final String token;
  final UserDto user;
  final String message;

  AuthResultDto({
    required this.token,
    required this.user,
    required this.message,
  });

  factory AuthResultDto.fromJson(Map<String, dynamic> json) {
    return AuthResultDto(
      token: json['token'],
      user: UserDto.fromJson(json['user']),
      message: json['message'],
    );
  }

  AuthResult toDomain() {
    return AuthResult(accessToken: token, currentUser: user.toDomain());
  }
}

class UserDto {
  final int id;
  final String username;
  final String role;

  UserDto({required this.id, required this.username, required this.role});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      username: json['username'],
      role: json['role'],
    );
  }

  CurrentUser toDomain() {
    return CurrentUser(
      id: id,
      username: username,
      role: UserRole.values.firstWhere((e) => e.name == role),
    );
  }
}
