part of 'two_ndfl_request_bloc.dart';

enum TwoNdflRequestField { purpose, period }

class TwoNdflRequestState extends Equatable {
  final Map<TwoNdflRequestField, dynamic> fields;
  final Map<TwoNdflRequestField, String?> errors;
  final bool isSubmitting;
  final bool isSuccess;

  const TwoNdflRequestState({
    required this.fields,
    required this.errors,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  factory TwoNdflRequestState.initial() => const TwoNdflRequestState(
    fields: {
      TwoNdflRequestField.purpose: null,
      TwoNdflRequestField.period: null,
    },
    errors: {},
  );

  TwoNdflRequestState copyWith({
    Map<TwoNdflRequestField, dynamic>? fields,
    Map<TwoNdflRequestField, String?>? errors,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return TwoNdflRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [fields, errors, isSubmitting, isSuccess];

  bool get isFormValid {
    return fields[TwoNdflRequestField.purpose] != null &&
        fields[TwoNdflRequestField.period] != null &&
        (errors.isEmpty ||
            (errors[TwoNdflRequestField.purpose] == null &&
                errors[TwoNdflRequestField.period] == null));
  }
}
