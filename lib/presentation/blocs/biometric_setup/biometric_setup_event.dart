part of 'biometric_setup_bloc.dart';

abstract class BiometricSetupEvent {}

class CheckBiometricAvailability extends BiometricSetupEvent {
  final BiometricType type;
  CheckBiometricAvailability(this.type);
}

class TurnOnBiometric extends BiometricSetupEvent {}

class SkipBiometricSetup extends BiometricSetupEvent {}
