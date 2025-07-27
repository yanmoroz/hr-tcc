part of 'pincode_login_bloc.dart';

abstract class PincodeLoginEvent {
  const PincodeLoginEvent();
}

class PincodeNumberEnteredOnLoginStep extends PincodeLoginEvent {
  final String number;
  PincodeNumberEnteredOnLoginStep(this.number);
}

class PincodeBackspacePressedOnLoginStep extends PincodeLoginEvent {}

class BiometricAuthRequested extends PincodeLoginEvent {}

class InitializeBiometrics extends PincodeLoginEvent {
  const InitializeBiometrics();
}

class VerifyPincode extends PincodeLoginEvent {
  final String pincode;

  const VerifyPincode(this.pincode);
}

class AuthenticateWithBiometricsOnPinStep extends PincodeLoginEvent {
  const AuthenticateWithBiometricsOnPinStep();
}

class ResetPincode extends PincodeLoginEvent {
  const ResetPincode();
}
