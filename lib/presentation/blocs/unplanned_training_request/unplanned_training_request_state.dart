part of 'unplanned_training_request_bloc.dart';

class UnplannedTrainingRequestState extends Equatable {
  final Map<UnplannedTrainingRequestField, dynamic> fields;
  final Map<UnplannedTrainingRequestField, String?> errors;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFormValid;

  const UnplannedTrainingRequestState({
    required this.fields,
    required this.errors,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFormValid = false,
  });

  UnplannedTrainingRequestState copyWith({
    Map<UnplannedTrainingRequestField, dynamic>? fields,
    Map<UnplannedTrainingRequestField, String?>? errors,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFormValid,
  }) {
    return UnplannedTrainingRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
    fields,
    errors,
    isSubmitting,
    isSuccess,
    isFormValid,
  ];
}
