import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/entities.dart' as entities;
import 'package:hr_tcc/domain/entities/pass_request.dart';
import 'package:hr_tcc/domain/entities/request_dropdowns.dart';
import 'package:hr_tcc/domain/usecases/create_pass_request_usecase.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart'
    as courier_models;

part 'pass_request_event.dart';
part 'pass_request_state.dart';

class PassRequestBloc extends Bloc<PassRequestEvent, PassRequestState> {
  final CreatePassRequestUseCase createUseCase;

  PassRequestBloc(this.createUseCase) : super(PassRequestState.initial()) {
    on<PassRequestFieldChanged>(_onFieldChanged);
    on<PassRequestSubmitted>(_onSubmitted);
    on<PassRequestReset>(_onReset);
    on<PassRequestFieldBlurred>(_onFieldBlurred);
  }

  void _onFieldChanged(
    PassRequestFieldChanged event,
    Emitter<PassRequestState> emit,
  ) {
    final newFields = Map<entities.PassRequestField, dynamic>.from(state.fields)
      ..[event.field] = event.value;
    // Автоматическая логика выбора офиса по этажу
    if (event.field == entities.PassRequestField.floor) {
      final int floor = event.value;
      final matchingOffices =
          entities.offices.where((o) => o.floors.contains(floor)).toList();
      if (matchingOffices.isNotEmpty) {
        newFields[entities.PassRequestField.office] = matchingOffices.first;
      }
    }
    // Если выбран офис, фильтруем этажи
    if (event.field == entities.PassRequestField.office) {
      final office = event.value;
      if (!office.floors.contains(newFields[entities.PassRequestField.floor])) {
        newFields[entities.PassRequestField.floor] = office.floors.first;
      }
    }
    emit(state.copyWith(fields: newFields, errors: state.validate(newFields)));
  }

  Future<void> _onSubmitted(
    PassRequestSubmitted event,
    Emitter<PassRequestState> emit,
  ) async {
    final errors = state.validate(state.fields);
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors, submitted: true));
      return;
    }
    emit(state.copyWith(loading: true));
    final fields = state.fields;
    final isPermanent =
        fields[entities.PassRequestField.type] == entities.PassType.permanent;
    dynamic visitorsForBackend;
    if (isPermanent) {
      visitorsForBackend =
          (fields[entities.PassRequestField.visitors]
                  as List<courier_models.Employee>?)
              ?.map((e) => e.toJson())
              .toList() ??
          [];
    } else {
      visitorsForBackend =
          (fields[entities.PassRequestField.visitors] as List<String>);
    }
    final request = entities.PassRequest(
      id: UniqueKey().toString(),
      type: fields[entities.PassRequestField.type],
      legalEntity: fields[entities.PassRequestField.legalEntity],
      purpose: fields[entities.PassRequestField.purpose],
      floor: fields[entities.PassRequestField.floor],
      office: fields[entities.PassRequestField.office],
      dateRange: isPermanent ? null : fields[entities.PassRequestField.date],
      timeFrom: isPermanent ? null : fields[entities.PassRequestField.timeFrom],
      timeTo: isPermanent ? null : fields[entities.PassRequestField.timeTo],
      visitors: visitorsForBackend,
      otherPurpose: fields[entities.PassRequestField.otherPurpose],
      dateOfStart: fields[entities.PassRequestField.dateOfStart],
      photo: fields[entities.PassRequestField.photo],
      entryPoint: fields[entities.PassRequestField.entryPoint],
      status: entities.RequestStatus.newRequest,
      createdAt: DateTime.now(),
    );
    await createUseCase(request);
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(loading: false, success: true));
  }

  void _onReset(PassRequestReset event, Emitter<PassRequestState> emit) {
    emit(PassRequestState.initial());
  }

  void _onFieldBlurred(
    PassRequestFieldBlurred event,
    Emitter<PassRequestState> emit,
  ) {
    final newErrors = Map<entities.PassRequestField, String?>.from(
      state.errors,
    );
    final value = state.fields[event.field];
    final requiredFields = [
      entities.PassRequestField.type,
      entities.PassRequestField.purpose,
      entities.PassRequestField.office,
      entities.PassRequestField.floor,
      entities.PassRequestField.date,
      entities.PassRequestField.timeFrom,
      entities.PassRequestField.timeTo,
      entities.PassRequestField.visitors,
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
    // Особая проверка для otherPurpose
    if (event.field == entities.PassRequestField.otherPurpose &&
        (value == null || (value is String && value.trim().isEmpty))) {
      newErrors[event.field] = 'Укажите цель';
    } else if (event.field == entities.PassRequestField.otherPurpose) {
      newErrors.remove(event.field);
    }
    emit(state.copyWith(errors: newErrors));
  }
}
