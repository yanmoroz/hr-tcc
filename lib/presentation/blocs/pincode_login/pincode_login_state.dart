part of 'pincode_login_bloc.dart';

class PincodeLoginState {
  final String currentPincode;
  final bool isLoading;
  final String? error;
  final AuthType authType;
  final bool isBiometricAvailable;
  final bool isFaceIdAvailable;
  final bool isTouchIdAvailable;
  final bool isAuthenticated;

  const PincodeLoginState({
    this.currentPincode = '',
    this.isLoading = false,
    this.error,
    required this.authType,
    this.isBiometricAvailable = false,
    this.isFaceIdAvailable = false,
    this.isTouchIdAvailable = false,
    this.isAuthenticated = false,
  });

  PincodeLoginState copyWith({
    String? currentPincode,
    bool? isLoading,
    String? error,
    AuthType? authType,
    bool? isBiometricAvailable,
    bool? isFaceIdAvailable,
    bool? isTouchIdAvailable,
    bool? isAuthenticated,
  }) {
    return PincodeLoginState(
      currentPincode: currentPincode ?? this.currentPincode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      authType: authType ?? this.authType,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      isFaceIdAvailable: isFaceIdAvailable ?? this.isFaceIdAvailable,
      isTouchIdAvailable: isTouchIdAvailable ?? this.isTouchIdAvailable,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
