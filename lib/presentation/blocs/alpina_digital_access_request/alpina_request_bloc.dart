import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/alpina_digital_access_request_models.dart';

part 'alpina_request_event.dart';
part 'alpina_request_state.dart';

class AlpinaRequestBloc extends Bloc<AlpinaRequestEvent, AlpinaRequestState> {
  AlpinaRequestBloc() : super(AlpinaRequestState.initial()) {
    on<AlpinaRequestFieldChanged>(_onFieldChanged);
    on<AlpinaRequestCheckboxChanged>(_onCheckboxChanged);
    on<AlpinaRequestSubmit>(_onSubmit);
  }

  void _onFieldChanged(
    AlpinaRequestFieldChanged event,
    Emitter<AlpinaRequestState> emit,
  ) {
    final newFields = Map<AlpinaDigitalAccessRequestField, dynamic>.from(
      state.fields,
    );
    newFields[event.field] = event.value;
    final isFormValid = _calculateFormValid(newFields, state.isChecked);
    emit(state.copyWith(fields: newFields, isFormValid: isFormValid));
  }

  void _onCheckboxChanged(
    AlpinaRequestCheckboxChanged event,
    Emitter<AlpinaRequestState> emit,
  ) {
    final isFormValid = _calculateFormValid(state.fields, event.value);
    emit(state.copyWith(isChecked: event.value, isFormValid: isFormValid));
  }

  bool _calculateFormValid(
    Map<AlpinaDigitalAccessRequestField, dynamic> fields,
    bool isChecked,
  ) {
    if (fields[AlpinaDigitalAccessRequestField.date] == null) return false;
    if (fields[AlpinaDigitalAccessRequestField.wasAccessProvided] == null) {
      return false;
    }
    if (!isChecked) return false;
    if (fields[AlpinaDigitalAccessRequestField.addComment] == true &&
        (fields[AlpinaDigitalAccessRequestField.comment] as String)
            .trim()
            .isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _onSubmit(
    AlpinaRequestSubmit event,
    Emitter<AlpinaRequestState> emit,
  ) async {
    final errors = <AlpinaDigitalAccessRequestField, String?>{};
    if (state.fields[AlpinaDigitalAccessRequestField.date] == null) {
      errors[AlpinaDigitalAccessRequestField.date] = 'Обязательное поле';
    }
    if (state.fields[AlpinaDigitalAccessRequestField.wasAccessProvided] ==
        null) {
      errors[AlpinaDigitalAccessRequestField.wasAccessProvided] =
          'Обязательное поле';
    }
    if (!state.isChecked) {
      errors[AlpinaDigitalAccessRequestField.checkbox] = 'Необходимо согласие';
    }
    if (state.fields[AlpinaDigitalAccessRequestField.addComment] == true &&
        (state.fields[AlpinaDigitalAccessRequestField.comment] as String)
            .trim()
            .isEmpty) {
      errors[AlpinaDigitalAccessRequestField.comment] = 'Введите комментарий';
    }
    emit(
      state.copyWith(
        errors: errors,
        isFormValid: errors.isEmpty,
        isSubmitting: false,
      ),
    );
    if (errors.isNotEmpty) {
      return;
    }
    emit(state.copyWith(isSubmitting: true, errors: {}, isFormValid: true));
    await Future.delayed(const Duration(seconds: 1));
    emit(
      state.copyWith(isSubmitting: false, isSuccess: true, isFormValid: true),
    );
  }
}
