abstract class AccessTokenRepository {
  Future<String?> getAccessToken();
  Future<void> deleteAccessToken();
  Future<void> updateAccessToken(String accessToken);
}
