import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/auth_type.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveAuthType(AuthType type) async {
    await _secureStorage.write(
      key: AppConstants.authTypeKey,
      value: type.toString(),
    );
  }

  @override
  Future<AuthType?> getAuthType() async {
    final value = await _secureStorage.read(key: AppConstants.authTypeKey);
    if (value == null) return null;
    return AuthType.fromString(value);
  }

  @override
  Future<void> clearAuthType() async {
    await _secureStorage.delete(key: AppConstants.authTypeKey);
  }
}
