import 'package:flutter_bloc/flutter_bloc.dart';

part 'work_certificate_request_event.dart';
part 'work_certificate_request_state.dart';

class WorkCertificateRequestBloc
    extends Bloc<WorkCertificateRequestEvent, WorkCertificateRequestState> {
  WorkCertificateRequestBloc() : super(WorkCertificateRequestState.initial()) {
    on<WorkCertificateRequestFieldChanged>(_onFieldChanged);
    on<WorkCertificateRequestFieldBlurred>(_onFieldBlurred);
    on<WorkCertificateRequestSubmit>(_onSubmit);
  }

  void _onFieldChanged(
    WorkCertificateRequestFieldChanged event,
    Emitter<WorkCertificateRequestState> emit,
  ) {
    final newFields = {...state.fields, event.field: event.value};
    final errors = _validate(newFields, state.touchedFields, false);
    final isFormValid =
        _validate(newFields, {
          WorkCertificateRequestField.purpose,
          WorkCertificateRequestField.receiveDate,
          WorkCertificateRequestField.copiesCount,
        }, true).isEmpty;
    emit(
      state.copyWith(
        fields: newFields,
        errors: errors,
        isFormValid: isFormValid,
      ),
    );
  }

  void _onFieldBlurred(
    WorkCertificateRequestFieldBlurred event,
    Emitter<WorkCertificateRequestState> emit,
  ) {
    final newTouched = Set<WorkCertificateRequestField>.from(
      state.touchedFields,
    )..add(event.field);
    final errors = _validate(state.fields, newTouched, false);
    final isFormValid =
        _validate(state.fields, {
          WorkCertificateRequestField.purpose,
          WorkCertificateRequestField.receiveDate,
          WorkCertificateRequestField.copiesCount,
        }, true).isEmpty;
    emit(
      state.copyWith(
        touchedFields: newTouched,
        errors: errors,
        isFormValid: isFormValid,
      ),
    );
  }

  Future<void> _onSubmit(
    WorkCertificateRequestSubmit event,
    Emitter<WorkCertificateRequestState> emit,
  ) async {
    final requiredFields = {
      WorkCertificateRequestField.purpose,
      WorkCertificateRequestField.receiveDate,
      WorkCertificateRequestField.copiesCount,
    };
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
    emit(state.copyWith(isSuccess: false));
  }

  Map<WorkCertificateRequestField, String?> _validate(
    Map<WorkCertificateRequestField, dynamic> fields,
    Set<WorkCertificateRequestField> activeFields,
    bool isSubmitted,
  ) {
    final errors = <WorkCertificateRequestField, String?>{};
    void req(WorkCertificateRequestField key, String label) {
      if (!activeFields.contains(key) && !isSubmitted) return;
      final value = fields[key];
      if (value == null || (value is String && value.trim().isEmpty)) {
        errors[key] = 'Обязательное поле';
      }
    }

    req(WorkCertificateRequestField.purpose, 'Цель справки');
    req(WorkCertificateRequestField.receiveDate, 'Срок получения');
    req(WorkCertificateRequestField.copiesCount, 'Количество экземпляров');
    // Доп. валидация для количества экземпляров
    if ((activeFields.contains(WorkCertificateRequestField.copiesCount) ||
            isSubmitted) &&
        fields[WorkCertificateRequestField.copiesCount] != null) {
      final str = fields[WorkCertificateRequestField.copiesCount].toString();
      final num = int.tryParse(str);
      if (num == null || num < 1) {
        errors[WorkCertificateRequestField.copiesCount] =
            'Введите корректное количество (>0)';
      }
    }
    return errors;
  }
}
