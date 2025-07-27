import 'package:local_auth/local_auth.dart';

extension LocalAuthExtension on LocalAuthentication {
  /// Check if biometric authentication is available on the device
  Future<bool> isBiometricAvailable() async {
    try {
      final canAuthenticateWithBiometrics = await canCheckBiometrics;
      final canAuthenticate = await isDeviceSupported();

      return canAuthenticateWithBiometrics && canAuthenticate;
    } on Exception {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await getAvailableBiometrics();
    } on Exception {
      return [];
    }
  }

  Future<bool> authenticateWithBiometrics({
    String localizedReason = 'Пожалуйста, подтвердите свою личность',
  }) async {
    try {
      return await authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );
    } on Exception {
      return false;
    }
  }

  /// Check if a specific biometric type is available
  Future<bool> isBiometricTypeAvailable(BiometricType type) async {
    final isAvailable = await isBiometricAvailable();
    if (!isAvailable) return false;

    final biometrics = await getAvailableBiometrics();

    // On Android, biometrics can be detected as BiometricType.strong
    if (type == BiometricType.fingerprint) {
      return biometrics.contains(type) ||
          biometrics.contains(BiometricType.strong);
    }
    return biometrics.contains(type);
  }
}
