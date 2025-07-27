import 'package:local_auth/local_auth.dart';

import '../../domain/entities/auth_type.dart';

extension AuthTypeExtension on AuthType {
  static AuthType fromBiometricType(BiometricType type) {
    return switch (type) {
      BiometricType.face => AuthType.pincodeWithFaceID,
      BiometricType.fingerprint => AuthType.pincodeWithTouchID,
      _ => AuthType.pincodeOnly,
    };
  }
}
