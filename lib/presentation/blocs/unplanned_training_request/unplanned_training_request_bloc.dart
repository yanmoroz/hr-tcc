import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:hr_tcc/domain/usecases/create_unplanned_training_request_usecase.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

part 'unplanned_training_request_event.dart';
part 'unplanned_training_request_state.dart';

class UnplannedTrainingRequestBloc
    extends Bloc<UnplannedTrainingRequestEvent, UnplannedTrainingRequestState> {
  final CreateUnplannedTrainingRequestUseCase createUseCase;

  UnplannedTrainingRequestBloc(this.createUseCase)
    : super(const UnplannedTrainingRequestState(fields: {}, errors: {})) {
    on<UnplannedTrainingFieldChanged>(_onFieldChanged);
    on<UnplannedTrainingSubmit>(_onSubmit);
    on<UnplannedTrainingFieldBlurred>(_onFieldBlurred);
  }

  void _onFieldChanged(
    UnplannedTrainingFieldChanged event,
    Emitter<UnplannedTrainingRequestState> emit,
  ) {
    final newFields = Map<UnplannedTrainingRequestField, dynamic>.from(
      state.fields,
    );
    newFields[event.field] = event.value;
    final newErrors = Map<UnplannedTrainingRequestField, String?>.from(
      state.errors,
    );
    newErrors[event.field] = null;
    emit(
      state.copyWith(
        fields: newFields,
        errors: newErrors,
        isFormValid: _validate(newFields),
      ),
    );
  }

  Future<void> _onSubmit(
    UnplannedTrainingSubmit event,
    Emitter<UnplannedTrainingRequestState> emit,
  ) async {
    final errors = _validateFields(state.fields);
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors, isFormValid: false));
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    try {
      final request = _buildRequest(state.fields);
      await createUseCase(request);
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on Exception catch (_) {
      emit(state.copyWith(isSubmitting: false));
    }
  }

  void _onFieldBlurred(
    UnplannedTrainingFieldBlurred event,
    Emitter<UnplannedTrainingRequestState> emit,
  ) {
    final newFields = Map<UnplannedTrainingRequestField, dynamic>.from(
      state.fields,
    );
    final newErrors = Map<UnplannedTrainingRequestField, String?>.from(
      state.errors,
    );
    final field = event.field;
    // Проверяем только это поле
    final errors = _validateFields(newFields);
    if (errors.containsKey(field)) {
      newErrors[field] = errors[field];
    } else {
      newErrors[field] = null;
    }
    emit(state.copyWith(errors: newErrors));
  }

  bool _validate(Map<UnplannedTrainingRequestField, dynamic> fields) {
    // Строгая валидация для кнопки
    final manager = fields[UnplannedTrainingRequestField.manager];
    final approver = fields[UnplannedTrainingRequestField.approver];
    final organizer = fields[UnplannedTrainingRequestField.organizer];
    final eventName = fields[UnplannedTrainingRequestField.eventName];
    final type = fields[UnplannedTrainingRequestField.type];
    final form = fields[UnplannedTrainingRequestField.form];
    final unknownDates =
        fields[UnplannedTrainingRequestField.unknownDates] == true;
    final month = fields[UnplannedTrainingRequestField.month];
    final startDate = fields[UnplannedTrainingRequestField.startDate];
    final endDate = fields[UnplannedTrainingRequestField.endDate];
    final cost = fields[UnplannedTrainingRequestField.cost];
    final goal = fields[UnplannedTrainingRequestField.goal];
    final employees = fields[UnplannedTrainingRequestField.employees];
    final organizerName = fields[UnplannedTrainingRequestField.organizerName];

    final isManagerValid = manager != null && (manager as String).isNotEmpty;
    final isApproverValid = approver != null && (approver as String).isNotEmpty;
    final isOrganizerValid = organizer != null;
    final isEventNameValid =
        eventName != null && (eventName as String).isNotEmpty;
    final isTypeValid = type != null;
    final isFormValid = form != null;
    final isMonthValid = unknownDates ? month != null : true;
    final isStartDateValid = unknownDates ? true : startDate != null;
    final isEndDateValid = unknownDates ? true : endDate != null;
    final isCostValid = cost != null && (cost as String).isNotEmpty;
    final isGoalValid = goal != null && (goal as String).isNotEmpty;
    final isEmployeesValid =
        employees != null && (employees is List) && employees.isNotEmpty;
    final isOrganizerNameValid =
        organizer != UnplannedTrainingOrganizer.other ||
        (organizerName != null && (organizerName as String).isNotEmpty);

    return isManagerValid &&
        isApproverValid &&
        isOrganizerValid &&
        isEventNameValid &&
        isTypeValid &&
        isFormValid &&
        isMonthValid &&
        isStartDateValid &&
        isEndDateValid &&
        isCostValid &&
        isGoalValid &&
        isEmployeesValid &&
        isOrganizerNameValid;
  }

  Map<UnplannedTrainingRequestField, String?> _validateFields(
    Map<UnplannedTrainingRequestField, dynamic> fields,
  ) {
    final errors = <UnplannedTrainingRequestField, String?>{};
    if (fields[UnplannedTrainingRequestField.manager] == null) {
      errors[UnplannedTrainingRequestField.manager] = 'Обязательное поле';
    }
    if (fields[UnplannedTrainingRequestField.approver] == null) {
      errors[UnplannedTrainingRequestField.approver] = 'Обязательное поле';
    }
    if (fields[UnplannedTrainingRequestField.organizer] == null) {
      errors[UnplannedTrainingRequestField.organizer] = 'Обязательное поле';
    }
    if (fields[UnplannedTrainingRequestField.organizer] ==
            UnplannedTrainingOrganizer.other &&
        (fields[UnplannedTrainingRequestField.organizerName] == null ||
            (fields[UnplannedTrainingRequestField.organizerName] as String)
                .isEmpty)) {
      errors[UnplannedTrainingRequestField.organizerName] =
          'Укажите название организатора';
    }
    if (fields[UnplannedTrainingRequestField.eventName] == null ||
        (fields[UnplannedTrainingRequestField.eventName] as String).isEmpty) {
      errors[UnplannedTrainingRequestField.eventName] = 'Обязательное поле';
    }
    if (fields[UnplannedTrainingRequestField.type] == null) {
      errors[UnplannedTrainingRequestField.type] = 'Обязательное поле';
    }
    if (fields[UnplannedTrainingRequestField.form] == null) {
      errors[UnplannedTrainingRequestField.form] = 'Обязательное поле';
    }
    if (fields[UnplannedTrainingRequestField.unknownDates] == true) {
      if (fields[UnplannedTrainingRequestField.month] == null) {
        errors[UnplannedTrainingRequestField.month] = 'Укажите месяц';
      }
    } else {
      if (fields[UnplannedTrainingRequestField.startDate] == null) {
        errors[UnplannedTrainingRequestField.startDate] = 'Обязательное поле';
      }
      if (fields[UnplannedTrainingRequestField.endDate] == null) {
        errors[UnplannedTrainingRequestField.endDate] = 'Обязательное поле';
      }
    }
    final startDate =
        fields[UnplannedTrainingRequestField.startDate] as DateTime?;
    final endDate = fields[UnplannedTrainingRequestField.endDate] as DateTime?;
    if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
      errors[UnplannedTrainingRequestField.endDate] =
          'Дата окончания не может быть раньше даты начала';
    }
    if (fields[UnplannedTrainingRequestField.cost] == null ||
        (fields[UnplannedTrainingRequestField.cost] as String).isEmpty) {
      errors[UnplannedTrainingRequestField.cost] = 'Обязательное поле';
    }
    if (fields[UnplannedTrainingRequestField.goal] == null ||
        (fields[UnplannedTrainingRequestField.goal] as String).isEmpty) {
      errors[UnplannedTrainingRequestField.goal] = 'Обязательное поле';
    }
    if (fields[UnplannedTrainingRequestField.employees] == null ||
        (fields[UnplannedTrainingRequestField.employees] as List).isEmpty) {
      errors[UnplannedTrainingRequestField.employees] =
          'Укажите хотя бы одного сотрудника';
    }
    return errors;
  }

  UnplannedTrainingRequest _buildRequest(
    Map<UnplannedTrainingRequestField, dynamic> fields,
  ) {
    return UnplannedTrainingRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      manager: fields[UnplannedTrainingRequestField.manager] as String,
      approver: fields[UnplannedTrainingRequestField.approver] as String,
      organizer:
          fields[UnplannedTrainingRequestField.organizer]
              as UnplannedTrainingOrganizer,
      organizerName:
          fields[UnplannedTrainingRequestField.organizerName] as String?,
      eventName: fields[UnplannedTrainingRequestField.eventName] as String,
      type: fields[UnplannedTrainingRequestField.type] as UnplannedTrainingType,
      form: fields[UnplannedTrainingRequestField.form] as UnplannedTrainingForm,
      startDate: fields[UnplannedTrainingRequestField.startDate] as DateTime?,
      endDate: fields[UnplannedTrainingRequestField.endDate] as DateTime?,
      unknownDates:
          fields[UnplannedTrainingRequestField.unknownDates] as bool? ?? false,
      month:
          fields[UnplannedTrainingRequestField.month]
              as UnplannedTrainingMonth?,
      cost: fields[UnplannedTrainingRequestField.cost] as String,
      goal: fields[UnplannedTrainingRequestField.goal] as String,
      courseLink: fields[UnplannedTrainingRequestField.courseLink] as String?,
      employees:
          (fields[UnplannedTrainingRequestField.employees]
              as List<Employee>?) ??
          [],
      status: RequestStatus.active,
      createdAt: DateTime.now(),
    );
  }
}
