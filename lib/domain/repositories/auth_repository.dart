import '../core/result.dart';
import '../entities/auth_type.dart';
import '../models/auth_result.dart';
import '../models/logout_result.dart';

abstract class AuthRepository {
  Future<Result<AuthResult>> login(String username, String password);
  Future<Result<LogoutResult>> logout();
  Future<void> updateAuthType(AuthType type);
  Future<AuthType?> getAuthType();
  Future<void> resetAuthType();
}
