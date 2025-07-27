import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'two_ndfl_request_event.dart';
part 'two_ndfl_request_state.dart';

class TwoNdflRequestBloc
    extends Bloc<TwoNdflRequestEvent, TwoNdflRequestState> {
  TwoNdflRequestBloc() : super(TwoNdflRequestState.initial()) {
    on<TwoNdflRequestFieldChanged>(_onFieldChanged);
    on<TwoNdflRequestFieldBlurred>(_onFieldBlurred);
    on<TwoNdflRequestSubmit>(_onSubmit);
  }

  void _onFieldChanged(
    TwoNdflRequestFieldChanged event,
    Emitter<TwoNdflRequestState> emit,
  ) {
    final newFields = Map<TwoNdflRequestField, dynamic>.from(state.fields);
    newFields[event.field] = event.value;
    emit(state.copyWith(fields: newFields));
  }

  void _onFieldBlurred(
    TwoNdflRequestFieldBlurred event,
    Emitter<TwoNdflRequestState> emit,
  ) {
    final errors = _validate(state.fields);
    emit(state.copyWith(errors: errors));
  }

  Future<void> _onSubmit(
    TwoNdflRequestSubmit event,
    Emitter<TwoNdflRequestState> emit,
  ) async {
    final errors = _validate(state.fields);
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }

  Map<TwoNdflRequestField, String?> _validate(
    Map<TwoNdflRequestField, dynamic> fields,
  ) {
    final errors = <TwoNdflRequestField, String?>{};
    if (fields[TwoNdflRequestField.purpose] == null) {
      errors[TwoNdflRequestField.purpose] = 'Выберите цель справки';
    }
    if (fields[TwoNdflRequestField.period] == null) {
      errors[TwoNdflRequestField.period] = 'Выберите период';
    } else if (fields[TwoNdflRequestField.period] is! DateTimeRange) {
      errors[TwoNdflRequestField.period] = 'Некорректный период';
    }
    return errors;
  }
}
