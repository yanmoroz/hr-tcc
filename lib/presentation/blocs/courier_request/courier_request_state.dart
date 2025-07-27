part of 'courier_request_bloc.dart';

class CourierRequestState {
  final CourierDeliveryType deliveryType;
  final Map<CourierRequestField, dynamic> fields;
  final Map<CourierRequestField, dynamic> dropdowns;
  final List<Office> offices;
  final List<Employee> employees;
  final List<TripGoal> tripGoals;
  final bool loading;
  final Map<CourierRequestField, String?> errors;
  final bool isFormValid;
  final bool isSubmitting;
  final bool isSuccess;
  final Set<CourierRequestField> touchedFields;
  final bool isSubmitted;

  CourierRequestState({
    required this.deliveryType,
    required this.fields,
    required this.dropdowns,
    required this.offices,
    required this.employees,
    required this.tripGoals,
    required this.loading,
    required this.errors,
    required this.isFormValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.touchedFields,
    required this.isSubmitted,
  });

  factory CourierRequestState.initial() => CourierRequestState(
    deliveryType: CourierDeliveryType.moscow,
    fields: {},
    dropdowns: {},
    offices: [],
    employees: [],
    tripGoals: [],
    loading: false,
    errors: {},
    isFormValid: false,
    isSubmitting: false,
    isSuccess: false,
    touchedFields: {},
    isSubmitted: false,
  );

  CourierRequestState copyWith({
    CourierDeliveryType? deliveryType,
    Map<CourierRequestField, dynamic>? fields,
    Map<CourierRequestField, dynamic>? dropdowns,
    List<Office>? offices,
    List<Employee>? employees,
    List<TripGoal>? tripGoals,
    bool? loading,
    Map<CourierRequestField, String?>? errors,
    bool? isFormValid,
    bool? isSubmitting,
    bool? isSuccess,
    Set<CourierRequestField>? touchedFields,
    bool? isSubmitted,
  }) {
    return CourierRequestState(
      deliveryType: deliveryType ?? this.deliveryType,
      fields: fields ?? this.fields,
      dropdowns: dropdowns ?? this.dropdowns,
      offices: offices ?? this.offices,
      employees: employees ?? this.employees,
      tripGoals: tripGoals ?? this.tripGoals,
      loading: loading ?? this.loading,
      errors: errors ?? this.errors,
      isFormValid: isFormValid ?? this.isFormValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      touchedFields: touchedFields ?? this.touchedFields,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}
