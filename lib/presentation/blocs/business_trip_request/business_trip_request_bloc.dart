import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/requests/business_trip_request.dart';
import 'package:hr_tcc/domain/usecases/create_business_trip_request_usecase.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:hr_tcc/domain/usecases/get_employees_usecase.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

part 'business_trip_request_event.dart';
part 'business_trip_request_state.dart';

class BusinessTripRequestBloc
    extends Bloc<BusinessTripRequestEvent, BusinessTripRequestState> {
  final CreateBusinessTripRequestUseCase createUseCase;
  final GetEmployeesUseCase getEmployeesUseCase;
  BusinessTripRequestBloc(this.createUseCase, this.getEmployeesUseCase)
    : super(BusinessTripRequestState.initial()) {
    on<BusinessTripRequestFieldChanged>(_onFieldChanged);
    on<BusinessTripRequestFieldBlurred>(_onFieldBlurred);
    on<BusinessTripRequestSubmitted>(_onSubmitted);
    on<BusinessTripRequestReset>(_onReset);
    on<BusinessTripRequestLoadEmployees>(_onLoadEmployees);
  }

  void _onFieldChanged(
    BusinessTripRequestFieldChanged event,
    Emitter<BusinessTripRequestState> emit,
  ) {
    final newFields = Map<BusinessTripRequestField, dynamic>.from(state.fields);
    newFields[event.field] = event.value;
    final newErrors = state.validate(newFields);
    final isFormValid = state.validate(newFields).isEmpty;
    emit(
      state.copyWith(
        fields: newFields,
        errors: newErrors,
        isFormValid: isFormValid,
      ),
    );
  }

  void _onFieldBlurred(
    BusinessTripRequestFieldBlurred event,
    Emitter<BusinessTripRequestState> emit,
  ) {
    final newErrors = Map<BusinessTripRequestField, String?>.from(state.errors);
    final value = state.fields[event.field];
    final requiredFields = [
      BusinessTripRequestField.period,
      BusinessTripRequestField.fromCity,
      BusinessTripRequestField.toCity,
      BusinessTripRequestField.account,
      BusinessTripRequestField.purpose,
      BusinessTripRequestField.activity,
      BusinessTripRequestField.plannedEvents,
      BusinessTripRequestField.coordinatorService,
      BusinessTripRequestField.participants,
    ];
    if (requiredFields.contains(event.field)) {
      if (value == null ||
          (value is String && value.trim().isEmpty) ||
          (value is List && value.isEmpty)) {
        newErrors[event.field] = 'Обязательное поле';
      } else {
        newErrors.remove(event.field);
      }
    }
    final isFormValid = state.validate(state.fields).isEmpty;
    emit(state.copyWith(errors: newErrors, isFormValid: isFormValid));
  }

  Future<void> _onSubmitted(
    BusinessTripRequestSubmitted event,
    Emitter<BusinessTripRequestState> emit,
  ) async {
    final errors = state.validate(state.fields);
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors, submitted: true));
      return;
    }
    emit(state.copyWith(loading: true));
    final fields = state.fields;
    final request = BusinessTripRequest(
      id: UniqueKey().toString(),
      period: fields[BusinessTripRequestField.period],
      fromCity: fields[BusinessTripRequestField.fromCity],
      toCity: fields[BusinessTripRequestField.toCity],
      account: fields[BusinessTripRequestField.account],
      purpose: fields[BusinessTripRequestField.purpose],
      activity: fields[BusinessTripRequestField.activity],
      plannedEvents: fields[BusinessTripRequestField.plannedEvents],
      coordinatorService: fields[BusinessTripRequestField.coordinatorService],
      comment:
          (fields[BusinessTripRequestField.comment] as String).trim().isEmpty
              ? null
              : fields[BusinessTripRequestField.comment],
      participants: List<Employee>.from(
        fields[BusinessTripRequestField.participants],
      ),
      status: RequestStatus.newRequest,
      createdAt: DateTime.now(),
      purposeDescription:
          (fields[BusinessTripRequestField.purpose] ==
                  BusinessTripPurpose.other)
              ? fields[BusinessTripRequestField.purposeDescription]
              : null,
    );
    await createUseCase(request);
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(loading: false, success: true));
  }

  void _onReset(
    BusinessTripRequestReset event,
    Emitter<BusinessTripRequestState> emit,
  ) {
    emit(BusinessTripRequestState.initial());
  }

  Future<void> _onLoadEmployees(
    BusinessTripRequestLoadEmployees event,
    Emitter<BusinessTripRequestState> emit,
  ) async {
    emit(state.copyWith(employeesLoading: true, employeesError: null));
    try {
      final employees = await getEmployeesUseCase();
      emit(state.copyWith(employees: employees, employeesLoading: false));
    } on Exception catch (e) {
      emit(
        state.copyWith(employeesLoading: false, employeesError: e.toString()),
      );
    }
  }
}
