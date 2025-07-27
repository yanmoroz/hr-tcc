import '../../../domain/entities/auth_type.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthType(AuthType type);
  Future<AuthType?> getAuthType();
  Future<void> clearAuthType();
}
