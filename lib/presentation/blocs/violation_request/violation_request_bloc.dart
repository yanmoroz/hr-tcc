import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:hr_tcc/domain/entities/violation_request.dart';
import 'package:hr_tcc/domain/usecases/submit_violation_request_usecase.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

part 'violation_request_event.dart';
part 'violation_request_state.dart';

class ViolationRequestBloc
    extends Bloc<ViolationRequestEvent, ViolationRequestState> {
  final SubmitViolationRequestUseCase submitUseCase;

  ViolationRequestBloc(this.submitUseCase)
    : super(ViolationRequestState.initial()) {
    on<ViolationRequestFieldChanged>(_onFieldChanged);
    on<ViolationRequestCheckboxChanged>(_onCheckboxChanged);
    on<ViolationRequestFilesChanged>(_onFilesChanged);
    on<ViolationRequestSubmit>(_onSubmit);
    on<ViolationRequestFieldBlurred>(_onFieldBlurred);
  }

  void _onFieldChanged(
    ViolationRequestFieldChanged event,
    Emitter<ViolationRequestState> emit,
  ) {
    final newFields = Map<ViolationRequestField, dynamic>.from(state.fields);
    newFields[event.field] = event.value;
    final isFormValid = _calculateFormValid(newFields, state.isConfidential);
    emit(
      state.copyWith(fields: newFields, isFormValid: isFormValid, error: null),
    );
  }

  void _onCheckboxChanged(
    ViolationRequestCheckboxChanged event,
    Emitter<ViolationRequestState> emit,
  ) {
    final isFormValid = _calculateFormValid(state.fields, event.value);
    emit(
      state.copyWith(
        isConfidential: event.value,
        isFormValid: isFormValid,
        error: null,
      ),
    );
  }

  void _onFilesChanged(
    ViolationRequestFilesChanged event,
    Emitter<ViolationRequestState> emit,
  ) {
    emit(state.copyWith(files: event.files, error: null));
  }

  void _onFieldBlurred(
    ViolationRequestFieldBlurred event,
    Emitter<ViolationRequestState> emit,
  ) {
    final errors = Map<ViolationRequestField, String?>.from(state.errors);
    final value = state.fields[event.field];
    if ((value as String?)?.trim().isEmpty ?? true) {
      errors[event.field] =
          event.field == ViolationRequestField.subject
              ? 'Заполните тему'
              : 'Заполните описание';
    } else {
      errors.remove(event.field);
    }
    emit(state.copyWith(errors: errors));
  }

  bool _calculateFormValid(
    Map<ViolationRequestField, dynamic> fields,
    bool isConfidential,
  ) {
    final subject = fields[ViolationRequestField.subject] as String?;
    final description = fields[ViolationRequestField.description] as String?;

    if (subject?.trim().isEmpty ?? true) {
      return false;
    }

    if (description?.trim().isEmpty ?? true) {
      return false;
    }

    return true;
  }

  Future<void> _onSubmit(
    ViolationRequestSubmit event,
    Emitter<ViolationRequestState> emit,
  ) async {
    final errors = <ViolationRequestField, String?>{};
    if ((state.fields[ViolationRequestField.subject] as String?)
            ?.trim()
            .isEmpty ??
        true) {
      errors[ViolationRequestField.subject] = 'Заполните тему';
    }
    if ((state.fields[ViolationRequestField.description] as String?)
            ?.trim()
            .isEmpty ??
        true) {
      errors[ViolationRequestField.description] = 'Заполните описание';
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
    try {
      await submitUseCase(
        ViolationRequest(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          status: RequestStatus.newRequest,
          isConfidential: state.isConfidential,
          subject: state.fields[ViolationRequestField.subject] ?? '',
          description: state.fields[ViolationRequestField.description] ?? '',
          files: state.files,
          createdAt: DateTime.now(),
        ),
      );
      emit(
        state.copyWith(isSubmitting: false, isSuccess: true, isFormValid: true),
      );
    } on Exception catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}
