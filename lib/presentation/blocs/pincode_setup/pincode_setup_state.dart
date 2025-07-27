part of 'pincode_setup_bloc.dart';

class PincodeSetupState {
  final String currentPincode;
  final bool isConfirmation;
  final bool isSuccess;
  final String? error;

  const PincodeSetupState._({
    this.currentPincode = '',
    this.isConfirmation = false,
    this.isSuccess = false,
    this.error,
  });

  const PincodeSetupState.initial({bool isConfirmation = false})
    : this._(isConfirmation: isConfirmation);

  const PincodeSetupState.success(String pincode)
    : this._(currentPincode: pincode, isSuccess: true);

  const PincodeSetupState.error(
    String errorMessage, {
    bool isConfirmation = false,
    String currentPincode = '',
  }) : this._(
         error: errorMessage,
         isConfirmation: isConfirmation,
         currentPincode: currentPincode,
       );

  PincodeSetupState copyWith({
    String? currentPincode,
    bool? isConfirmation,
    bool? isSuccess,
    String? error,
  }) {
    return PincodeSetupState._(
      currentPincode: currentPincode ?? this.currentPincode,
      isConfirmation: isConfirmation ?? this.isConfirmation,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }
}
