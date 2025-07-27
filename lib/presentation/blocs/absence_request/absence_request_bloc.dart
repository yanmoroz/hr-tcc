import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/requests/requests.dart';
import 'package:hr_tcc/domain/usecases/create_absence_request_usecase.dart';
import 'package:flutter/material.dart';

part 'absence_request_event.dart';
part 'absence_request_state.dart';

class AbsenceRequestBloc
    extends Bloc<AbsenceRequestEvent, AbsenceRequestState> {
  final CreateAbsenceRequestUseCase createUseCase;

  Map<AbsenceRequestField, String?> _validateAllFields(
    Map<AbsenceRequestField, dynamic> fields,
  ) {
    final type =
        fields[AbsenceRequestField.type] as AbsenceType? ??
        AbsenceType.earlyLeave;
    final errors = <AbsenceRequestField, String?>{};
    const requiredError = 'Обязательное поле';
    if (type == AbsenceType.earlyLeave) {
      if (fields[AbsenceRequestField.date] == null) {
        errors[AbsenceRequestField.date] = requiredError;
      }
      if (fields[AbsenceRequestField.time] == null) {
        errors[AbsenceRequestField.time] = requiredError;
      }
      if ((fields[AbsenceRequestField.reason] as String?)?.trim().isEmpty ??
          true) {
        errors[AbsenceRequestField.reason] = requiredError;
      }
    } else if (type == AbsenceType.lateArrival) {
      if (fields[AbsenceRequestField.date] == null) {
        errors[AbsenceRequestField.date] = requiredError;
      }
      if (fields[AbsenceRequestField.time] == null) {
        errors[AbsenceRequestField.time] = requiredError;
      }
      if ((fields[AbsenceRequestField.reason] as String?)?.trim().isEmpty ??
          true) {
        errors[AbsenceRequestField.reason] = requiredError;
      }
    } else if (type == AbsenceType.workSchedule) {
      if (fields[AbsenceRequestField.period] == null) {
        errors[AbsenceRequestField.period] = requiredError;
      }
      if (fields[AbsenceRequestField.timeRangeStart] == null) {
        errors[AbsenceRequestField.timeRangeStart] = requiredError;
      }
      if (fields[AbsenceRequestField.timeRangeEnd] == null) {
        errors[AbsenceRequestField.timeRangeEnd] = requiredError;
      }
      if ((fields[AbsenceRequestField.reason] as String?)?.trim().isEmpty ??
          true) {
        errors[AbsenceRequestField.reason] = requiredError;
      }
      final start = fields[AbsenceRequestField.timeRangeStart] as TimeOfDay?;
      final end = fields[AbsenceRequestField.timeRangeEnd] as TimeOfDay?;
      if (start != null && end != null) {
        final startMinutes = start.hour * 60 + start.minute;
        final endMinutes = end.hour * 60 + end.minute;
        if (endMinutes <= startMinutes) {
          errors[AbsenceRequestField.timeRangeEnd] =
              '"График работы, часы «До»" должно быть больше чем "График работы, часы «С»"';
        }
      }
    } else if (type == AbsenceType.other) {
      if (fields[AbsenceRequestField.date] == null) {
        errors[AbsenceRequestField.date] = requiredError;
      }
      if (fields[AbsenceRequestField.timeRangeStart] == null) {
        errors[AbsenceRequestField.timeRangeStart] = requiredError;
      }
      if (fields[AbsenceRequestField.timeRangeEnd] == null) {
        errors[AbsenceRequestField.timeRangeEnd] = requiredError;
      }
      if ((fields[AbsenceRequestField.reason] as String?)?.trim().isEmpty ??
          true) {
        errors[AbsenceRequestField.reason] = requiredError;
      }
      final start = fields[AbsenceRequestField.timeRangeStart] as TimeOfDay?;
      final end = fields[AbsenceRequestField.timeRangeEnd] as TimeOfDay?;
      if (start != null && end != null) {
        final startMinutes = start.hour * 60 + start.minute;
        final endMinutes = end.hour * 60 + end.minute;
        if (endMinutes <= startMinutes) {
          errors[AbsenceRequestField.timeRangeEnd] =
              '"Период работы, часы «До»" должно быть больше чем "Период работы, часы «С»"';
        }
      }
    }
    return errors;
  }

  AbsenceRequestBloc(this.createUseCase)
    : super(AbsenceRequestState.initial()) {
    on<AbsenceRequestFieldChanged>(_onFieldChanged);
    on<AbsenceRequestSubmit>(_onSubmit);
    on<AbsenceRequestFieldBlurred>(_onFieldBlurred);
  }

  void _onFieldChanged(
    AbsenceRequestFieldChanged event,
    Emitter<AbsenceRequestState> emit,
  ) {
    Map<AbsenceRequestField, dynamic> newFields =
        Map<AbsenceRequestField, dynamic>.from(state.fields);
    Map<AbsenceRequestField, String?> newErrors =
        Map<AbsenceRequestField, String?>.from(state.errors);

    if (event.field == AbsenceRequestField.type) {
      // Сбросить только ошибки, значения оставить
      final AbsenceType newType = event.value as AbsenceType;
      newFields[AbsenceRequestField.type] = newType;
      newErrors = {};
    } else {
      newFields[event.field] = event.value;
    }
    newErrors = _validateAllFields(newFields);
    emit(
      state.copyWith(fields: newFields, isSuccess: false, errors: newErrors),
    );
  }

  void _onFieldBlurred(
    AbsenceRequestFieldBlurred event,
    Emitter<AbsenceRequestState> emit,
  ) {
    final errors = _validateAllFields(state.fields);
    emit(state.copyWith(errors: errors));
  }

  Future<void> _onSubmit(
    AbsenceRequestSubmit event,
    Emitter<AbsenceRequestState> emit,
  ) async {
    final errors = _validateAllFields(state.fields);
    if (errors.values.any((e) => e != null && e.isNotEmpty)) {
      emit(state.copyWith(errors: errors));
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    try {
      final request = AbsenceRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: state.fields[AbsenceRequestField.type] ?? AbsenceType.earlyLeave,
        date: state.fields[AbsenceRequestField.date],
        period: state.fields[AbsenceRequestField.period],
        time: state.fields[AbsenceRequestField.time],
        timeRangeStart: state.fields[AbsenceRequestField.timeRangeStart],
        timeRangeEnd: state.fields[AbsenceRequestField.timeRangeEnd],
        reason: state.fields[AbsenceRequestField.reason],
        status: RequestStatus.newRequest,
        createdAt: DateTime.now(),
      );
      await createUseCase(request);
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on Exception catch (_) {
      emit(
        state.copyWith(isSubmitting: false, error: 'Ошибка создания заявки'),
      );
    }
  }
}
