import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';

part 'work_book_request_event.dart';
part 'work_book_request_state.dart';

class WorkBookRequestBloc
    extends Bloc<WorkBookRequestEvent, WorkBookRequestState> {
  WorkBookRequestBloc() : super(WorkBookRequestState.initial()) {
    on<WorkBookRequestFieldChanged>(_onFieldChanged);
    on<WorkBookRequestFieldBlurred>(_onFieldBlurred);
    on<WorkBookRequestSubmit>(_onSubmit);
  }

  void _onFieldChanged(
    WorkBookRequestFieldChanged event,
    Emitter<WorkBookRequestState> emit,
  ) {
    final newFields = {...state.fields, event.field: event.value};
    final errors = _validate(newFields, state.touchedFields, false);
    final isFormValid =
        _validate(newFields, WorkBookRequestField.values.toSet(), true).isEmpty;
    emit(
      state.copyWith(
        fields: newFields,
        errors: errors,
        isFormValid: isFormValid,
      ),
    );
  }

  void _onFieldBlurred(
    WorkBookRequestFieldBlurred event,
    Emitter<WorkBookRequestState> emit,
  ) {
    final newTouched = Set<WorkBookRequestField>.from(state.touchedFields)
      ..add(event.field);
    final errors = _validate(state.fields, newTouched, false);
    final isFormValid =
        _validate(
          state.fields,
          WorkBookRequestField.values.toSet(),
          true,
        ).isEmpty;
    emit(
      state.copyWith(
        touchedFields: newTouched,
        errors: errors,
        isFormValid: isFormValid,
      ),
    );
  }

  Future<void> _onSubmit(
    WorkBookRequestSubmit event,
    Emitter<WorkBookRequestState> emit,
  ) async {
    final requiredFields = WorkBookRequestField.values.toSet();
    final errors = _validate(state.fields, requiredFields, true);
    final isFormValid = errors.isEmpty;
    if (!isFormValid) {
      emit(
        state.copyWith(
          errors: errors,
          isFormValid: false,
          isSubmitting: false,
          isSuccess: false,
          touchedFields: requiredFields,
        ),
      );
      return;
    }
    emit(state.copyWith(isSubmitting: true, isSuccess: false));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  Map<WorkBookRequestField, String?> _validate(
    Map<WorkBookRequestField, dynamic> fields,
    Set<WorkBookRequestField> activeFields,
    bool isSubmitted,
  ) {
    final errors = <WorkBookRequestField, String?>{};
    void req(WorkBookRequestField key, String label) {
      if (!activeFields.contains(key) && !isSubmitted) return;
      final value = fields[key];
      if (value == null || (value is String && value.trim().isEmpty)) {
        errors[key] = 'Обязательное поле';
      }
    }

    req(WorkBookRequestField.copiesCount, 'Количество экземпляров');
    req(WorkBookRequestField.receiveDate, 'Срок получения');
    return errors;
  }
}
