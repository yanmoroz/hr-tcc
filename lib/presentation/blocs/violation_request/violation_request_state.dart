part of 'violation_request_bloc.dart';

class ViolationRequestState {
  final Map<ViolationRequestField, dynamic> fields;
  final Map<ViolationRequestField, String?> errors;
  final bool isConfidential;
  final List<AppFileGridItem> files;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFormValid;
  final String? error;

  ViolationRequestState({
    required this.fields,
    required this.errors,
    required this.isConfidential,
    required this.files,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFormValid,
    this.error,
  });

  factory ViolationRequestState.initial() => ViolationRequestState(
    fields: {
      ViolationRequestField.subject: '',
      ViolationRequestField.description: '',
    },
    errors: {},
    isConfidential: false,
    files: const [],
    isSubmitting: false,
    isSuccess: false,
    isFormValid: false,
    error: null,
  );

  ViolationRequestState copyWith({
    Map<ViolationRequestField, dynamic>? fields,
    Map<ViolationRequestField, String?>? errors,
    bool? isConfidential,
    List<AppFileGridItem>? files,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFormValid,
    String? error,
  }) {
    return ViolationRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      isConfidential: isConfidential ?? this.isConfidential,
      files: files ?? this.files,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFormValid: isFormValid ?? this.isFormValid,
      error: error,
    );
  }
}
