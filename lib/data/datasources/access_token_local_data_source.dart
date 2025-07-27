import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_constants.dart';

abstract class AccessTokenLocalDataSource {
  Future<String?> getAccessToken();
  Future<void> deleteAccessToken();
  Future<void> updateAccessToken(String accessToken);
}

class AccessTokenLocalDataSourceImpl implements AccessTokenLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AccessTokenLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<String?> getAccessToken() async {
    return secureStorage.read(key: AppConstants.accessTokenKey);
  }

  @override
  Future<void> deleteAccessToken() async {
    return secureStorage.delete(key: AppConstants.accessTokenKey);
  }

  @override
  Future<void> updateAccessToken(String accessToken) async {
    return secureStorage.write(
      key: AppConstants.accessTokenKey,
      value: accessToken,
    );
  }
}
