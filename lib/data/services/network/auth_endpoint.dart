import '../../../core/constants/app_constants.dart';

enum AuthEndpoint { login, logout }

extension AuthEndpointExtension on AuthEndpoint {
  String get path {
    switch (this) {
      case AuthEndpoint.login:
        return '/auth/login';
      case AuthEndpoint.logout:
        return '/auth/logout';
    }
  }

  String get url => '${AppConstants.baseUrl}$path';
}
