import '../../domain/repositories/access_token_repository.dart';
import '../datasources/access_token_local_data_source.dart';

class AccessTokenRepositoryImpl implements AccessTokenRepository {
  final AccessTokenLocalDataSource accessTokenLocalDataSource;

  AccessTokenRepositoryImpl({required this.accessTokenLocalDataSource});

  @override
  Future<String?> getAccessToken() async {
    return await accessTokenLocalDataSource.getAccessToken();
  }

  @override
  Future<void> deleteAccessToken() async {
    return await accessTokenLocalDataSource.deleteAccessToken();
  }

  @override
  Future<void> updateAccessToken(String accessToken) async {
    return await accessTokenLocalDataSource.updateAccessToken(accessToken);
  }
}
