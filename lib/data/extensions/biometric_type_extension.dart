import 'package:local_auth/local_auth.dart';

extension BiometricTypeExtension on BiometricType {
  static BiometricType fromString(String value) {
    return BiometricType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => BiometricType.fingerprint,
    );
  }
}
