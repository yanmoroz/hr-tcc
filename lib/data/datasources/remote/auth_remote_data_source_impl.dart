import '../../../domain/services/network_service.dart';
import '../../services/network/auth_endpoint.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkService _networkService;

  AuthRemoteDataSourceImpl(this._networkService);

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _networkService.post(
        AuthEndpoint.login.url,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode != 200 || response.data['token'] == null) {
        throw Exception('Invalid credentials or server error');
      }

      return response.data;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _networkService.post(AuthEndpoint.logout.url);

      if (response.statusCode != 200) {
        throw Exception('Invalid token or server error');
      }

      return response.data;
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}
