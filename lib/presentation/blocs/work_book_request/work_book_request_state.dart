part of 'work_book_request_bloc.dart';

class WorkBookRequestState extends Equatable {
  final Map<WorkBookRequestField, dynamic> fields;
  final Map<WorkBookRequestField, String?> errors;
  final Set<WorkBookRequestField> touchedFields;
  final bool isFormValid;
  final bool isSubmitting;
  final bool isSuccess;

  const WorkBookRequestState({
    required this.fields,
    required this.errors,
    required this.touchedFields,
    required this.isFormValid,
    required this.isSubmitting,
    required this.isSuccess,
  });

  factory WorkBookRequestState.initial() => WorkBookRequestState(
    fields: {
      WorkBookRequestField.copiesCount: null,
      WorkBookRequestField.receiveDate: DateTime.now().add(
        const Duration(days: 3),
      ),
      WorkBookRequestField.isCertifiedCopy: false,
      WorkBookRequestField.isScanByEmail: false,
    },
    errors: const {},
    touchedFields: const {},
    isFormValid: false,
    isSubmitting: false,
    isSuccess: false,
  );

  WorkBookRequestState copyWith({
    Map<WorkBookRequestField, dynamic>? fields,
    Map<WorkBookRequestField, String?>? errors,
    Set<WorkBookRequestField>? touchedFields,
    bool? isFormValid,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return WorkBookRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      touchedFields: touchedFields ?? this.touchedFields,
      isFormValid: isFormValid ?? this.isFormValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    fields,
    errors,
    touchedFields,
    isFormValid,
    isSubmitting,
    isSuccess,
  ];
}
