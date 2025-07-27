import '../entities/current_user.dart';

class AuthResult {
  final String accessToken;
  final CurrentUser currentUser;

  AuthResult({required this.accessToken, required this.currentUser});
}
