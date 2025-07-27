part of 'work_certificate_request_bloc.dart';

enum WorkCertificateRequestField { purpose, receiveDate, copiesCount }

class WorkCertificateRequestState {
  final Map<WorkCertificateRequestField, dynamic> fields;
  final Map<WorkCertificateRequestField, String?> errors;
  final Set<WorkCertificateRequestField> touchedFields;
  final bool isFormValid;
  final bool isSubmitting;
  final bool isSuccess;

  WorkCertificateRequestState({
    required this.fields,
    required this.errors,
    required this.touchedFields,
    required this.isFormValid,
    required this.isSubmitting,
    required this.isSuccess,
  });

  factory WorkCertificateRequestState.initial() => WorkCertificateRequestState(
    fields: {
      WorkCertificateRequestField.purpose: null,
      WorkCertificateRequestField.receiveDate: null,
      WorkCertificateRequestField.copiesCount: '',
    },
    errors: {},
    touchedFields: {},
    isFormValid: false,
    isSubmitting: false,
    isSuccess: false,
  );

  WorkCertificateRequestState copyWith({
    Map<WorkCertificateRequestField, dynamic>? fields,
    Map<WorkCertificateRequestField, String?>? errors,
    Set<WorkCertificateRequestField>? touchedFields,
    bool? isFormValid,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return WorkCertificateRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      touchedFields: touchedFields ?? this.touchedFields,
      isFormValid: isFormValid ?? this.isFormValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
