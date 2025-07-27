part of 'pincode_setup_bloc.dart';

abstract class PincodeSetupEvent {}

class PincodeNumberEntered extends PincodeSetupEvent {
  final String number;

  PincodeNumberEntered.pincodeNumberEnteredOnSetupStep(this.number);
}

class PincodeBackspacePressedOnSetupStep extends PincodeSetupEvent {}

class ClearPincode extends PincodeSetupEvent {}
