import 'package:hr_tcc/domain/core/failures.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

import '../../domain/core/result.dart';
import '../../domain/entities/auth_type.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/models/logout_result.dart';
import '../../domain/services/network_info.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/auth_result_dto.dart';
import '../models/logout_result_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Result<AuthResult>> login(String username, String password) async {
    if (!await _networkInfo.isConnected) {
      return const Error(NetworkFailure('No internet connection'));
    }

    try {
      final response = await _authRemoteDataSource.login(username, password);
      final authResultDto = AuthResultDto.fromJson(response);
      final authResult = authResultDto.toDomain();
      return Success(authResult);
    } on Exception catch (e) {
      return Error(AuthFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<LogoutResult>> logout() async {
    if (!await _networkInfo.isConnected) {
      return const Error(NetworkFailure('No internet connection'));
    }

    try {
      final response = await _authRemoteDataSource.logout();
      final logoutResultDto = LogoutResultDto.fromJson(response);
      final logoutResult = logoutResultDto.toDomain();
      return Success(logoutResult);
    } on Exception catch (e) {
      return Error(AuthFailure('Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<void> updateAuthType(AuthType type) async {
    await _authLocalDataSource.saveAuthType(type);
  }

  @override
  Future<AuthType?> getAuthType() async {
    return _authLocalDataSource.getAuthType();
  }

  @override
  Future<void> resetAuthType() async {
    await _authLocalDataSource.clearAuthType();
  }
}
