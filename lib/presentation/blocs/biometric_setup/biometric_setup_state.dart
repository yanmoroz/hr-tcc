part of 'biometric_setup_bloc.dart';

enum BiometricSetupStatus { initial, inProgress, success, failure, skipped }

enum BiometricSetupAction { none, biometric, skip }

class BiometricSetupState {
  final bool isAvailable;
  final bool isAuthenticated;
  final String? error;
  final BiometricSetupStatus status;
  final BiometricSetupAction loadingAction;

  const BiometricSetupState({
    this.isAvailable = false,
    this.isAuthenticated = false,
    this.error,
    this.status = BiometricSetupStatus.initial,
    this.loadingAction = BiometricSetupAction.none,
  });

  BiometricSetupState copyWith({
    bool? isAvailable,
    bool? isAuthenticated,
    String? error,
    BiometricSetupStatus? status,
    BiometricSetupAction? loadingAction,
  }) {
    return BiometricSetupState(
      isAvailable: isAvailable ?? this.isAvailable,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
      status: status ?? this.status,
      loadingAction: loadingAction ?? this.loadingAction,
    );
  }
}
