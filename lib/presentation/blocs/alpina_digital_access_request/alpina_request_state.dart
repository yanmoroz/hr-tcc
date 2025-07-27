part of 'alpina_request_bloc.dart';

class AlpinaRequestState {
  final Map<AlpinaDigitalAccessRequestField, dynamic> fields;
  final Map<AlpinaDigitalAccessRequestField, String?> errors;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isChecked;
  final bool isFormValid;

  AlpinaRequestState({
    required this.fields,
    required this.errors,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isChecked,
    required this.isFormValid,
  });

  factory AlpinaRequestState.initial() => AlpinaRequestState(
    fields: {
      AlpinaDigitalAccessRequestField.date: null,
      AlpinaDigitalAccessRequestField.wasAccessProvided: false,
      AlpinaDigitalAccessRequestField.addComment: false,
      AlpinaDigitalAccessRequestField.comment: '',
    },
    errors: {},
    isSubmitting: false,
    isSuccess: false,
    isChecked: false,
    isFormValid: false,
  );

  AlpinaRequestState copyWith({
    Map<AlpinaDigitalAccessRequestField, dynamic>? fields,
    Map<AlpinaDigitalAccessRequestField, String?>? errors,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isChecked,
    bool? isFormValid,
  }) {
    return AlpinaRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isChecked: isChecked ?? this.isChecked,
      isFormValid: isFormValid ?? (errors ?? this.errors).isEmpty,
    );
  }
}
