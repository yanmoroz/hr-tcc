part of 'business_trip_request_bloc.dart';

class BusinessTripRequestState {
  final Map<BusinessTripRequestField, dynamic> fields;
  final Map<BusinessTripRequestField, String?> errors;
  final bool loading;
  final bool success;
  final bool submitted;
  final List<Employee> employees;
  final bool employeesLoading;
  final String? employeesError;
  final bool isFormValid;

  BusinessTripRequestState({
    required this.fields,
    required this.errors,
    required this.loading,
    required this.success,
    required this.submitted,
    required this.employees,
    required this.employeesLoading,
    required this.employeesError,
    required this.isFormValid,
  });

  factory BusinessTripRequestState.initial() => BusinessTripRequestState(
    fields: {
      BusinessTripRequestField.period: null,
      BusinessTripRequestField.fromCity: null,
      BusinessTripRequestField.toCity: null,
      BusinessTripRequestField.account: null,
      BusinessTripRequestField.purpose: null,
      BusinessTripRequestField.activity: null,
      BusinessTripRequestField.plannedEvents: '',
      BusinessTripRequestField.coordinatorService:
          TravelCoordinatorService.required,
      BusinessTripRequestField.comment: '',
      BusinessTripRequestField.participants: <Employee>[],
      BusinessTripRequestField.purposeDescription: '',
    },
    errors: {},
    loading: false,
    success: false,
    submitted: false,
    employees: const [],
    employeesLoading: false,
    employeesError: null,
    isFormValid: false,
  );

  BusinessTripRequestState copyWith({
    Map<BusinessTripRequestField, dynamic>? fields,
    Map<BusinessTripRequestField, String?>? errors,
    bool? loading,
    bool? success,
    bool? submitted,
    List<Employee>? employees,
    bool? employeesLoading,
    String? employeesError,
    bool? isFormValid,
  }) {
    return BusinessTripRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      loading: loading ?? this.loading,
      success: success ?? this.success,
      submitted: submitted ?? this.submitted,
      employees: employees ?? this.employees,
      employeesLoading: employeesLoading ?? this.employeesLoading,
      employeesError: employeesError ?? this.employeesError,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  bool get isSuccess => success;

  Map<BusinessTripRequestField, String?> validate(
    Map<BusinessTripRequestField, dynamic> fields,
  ) {
    final errors = <BusinessTripRequestField, String?>{};
    if (fields[BusinessTripRequestField.period] == null) {
      errors[BusinessTripRequestField.period] = 'Обязательное поле';
    }
    if (fields[BusinessTripRequestField.fromCity] == null) {
      errors[BusinessTripRequestField.fromCity] = 'Обязательное поле';
    }
    if (fields[BusinessTripRequestField.toCity] == null) {
      errors[BusinessTripRequestField.toCity] = 'Обязательное поле';
    }
    if (fields[BusinessTripRequestField.account] == null) {
      errors[BusinessTripRequestField.account] = 'Обязательное поле';
    }
    if (fields[BusinessTripRequestField.purpose] == null) {
      errors[BusinessTripRequestField.purpose] = 'Обязательное поле';
    }
    if (fields[BusinessTripRequestField.activity] == null) {
      errors[BusinessTripRequestField.activity] = 'Обязательное поле';
    }
    if (fields[BusinessTripRequestField.purpose] == BusinessTripPurpose.other) {
      if ((fields[BusinessTripRequestField.purposeDescription] as String)
          .trim()
          .isEmpty) {
        errors[BusinessTripRequestField.purposeDescription] =
            'Укажите текстовое описание цели';
      }
    }
    if ((fields[BusinessTripRequestField.plannedEvents] as String)
        .trim()
        .isEmpty) {
      errors[BusinessTripRequestField.plannedEvents] = 'Обязательное поле';
    }
    if (fields[BusinessTripRequestField.coordinatorService] == null) {
      errors[BusinessTripRequestField.coordinatorService] = 'Обязательное поле';
    }
    if ((fields[BusinessTripRequestField.participants] as List).isEmpty) {
      errors[BusinessTripRequestField.participants] =
          'Добавьте хотя бы одного командируемого';
    }
    // Комментарий не обязателен
    return errors;
  }
}
