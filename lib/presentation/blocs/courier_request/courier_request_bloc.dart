import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/domain/usecases/fetch_courier_request_data_usecase.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_fields_list.dart';

part 'courier_request_event.dart';
part 'courier_request_state.dart';

class CourierRequestBloc
    extends Bloc<CourierRequestEvent, CourierRequestState> {
  final FetchCourierRequestDataUseCase useCase;

  CourierRequestBloc(this.useCase) : super(CourierRequestState.initial()) {
    on<CourierRequestLoadData>(_onLoadData);
    on<CourierRequestDeliveryTypeChanged>(_onDeliveryTypeChanged);
    on<CourierRequestFieldChanged>(_onFieldChanged);
    on<CourierRequestDropdownChanged>(_onDropdownChanged);
    on<CourierRequestFieldBlurred>(_onFieldBlurred);
    on<CourierRequestSubmit>(_onSubmit);
  }

  Future<void> _onLoadData(
    CourierRequestLoadData event,
    Emitter<CourierRequestState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final offices = await useCase.fetchOffices();
    final employees = await useCase.fetchEmployees();
    final tripGoals = await useCase.fetchTripGoals();
    emit(
      state.copyWith(
        offices: offices,
        employees: employees,
        tripGoals: tripGoals,
        loading: false,
      ),
    );
  }

  void _onDeliveryTypeChanged(
    CourierRequestDeliveryTypeChanged event,
    Emitter<CourierRequestState> emit,
  ) {
    var newTouched = Set<CourierRequestField>.from(state.touchedFields);
    final newFields = Map<CourierRequestField, dynamic>.from(state.fields)
      ..[CourierRequestField.deliveryType] = event.deliveryType;
    final errors = _validate(
      newFields,
      state.dropdowns,
      newTouched,
      state.isSubmitted,
    );
    final isFormValid =
        _validate(
          newFields,
          state.dropdowns,
          allCourierRequestFields.toSet(),
          true,
        ).isEmpty;
    emit(
      state.copyWith(
        deliveryType: event.deliveryType,
        fields: newFields,
        touchedFields: newTouched,
        errors: errors,
        isFormValid: isFormValid,
        isSuccess: false,
      ),
    );
  }

  void _onFieldBlurred(
    CourierRequestFieldBlurred event,
    Emitter<CourierRequestState> emit,
  ) {
    final isRegions = state.deliveryType == CourierDeliveryType.regions;
    final newTouched = Set<CourierRequestField>.from(state.touchedFields);
    if (isRegions &&
        (event.field == CourierRequestField.expReason ||
            event.field == CourierRequestField.contentDesc)) {
      newTouched.add(CourierRequestField.expReason);
      newTouched.add(CourierRequestField.contentDesc);
    } else {
      newTouched.add(event.field);
    }
    final errors = _validate(
      state.fields,
      state.dropdowns,
      newTouched,
      state.isSubmitted,
    );
    final isFormValid =
        _validate(
          state.fields,
          state.dropdowns,
          allCourierRequestFields.toSet(),
          true,
        ).isEmpty;
    emit(
      state.copyWith(
        touchedFields: newTouched,
        errors: errors,
        isFormValid: isFormValid,
        isSuccess: false,
      ),
    );
  }

  void _onFieldChanged(
    CourierRequestFieldChanged event,
    Emitter<CourierRequestState> emit,
  ) {
    final newFields = {...state.fields, event.field: event.value};

    if (event.field == CourierRequestField.deadline) {
      newFields[CourierRequestField.priority] = _calcPriority(event.value);
    }
    final errors = _validate(
      newFields,
      state.dropdowns,
      state.touchedFields,
      state.isSubmitted,
    );
    final isFormValid =
        _validate(
          newFields,
          state.dropdowns,
          allCourierRequestFields.toSet(),
          true,
        ).isEmpty;
    emit(
      state.copyWith(
        fields: newFields,
        errors: errors,
        isFormValid: isFormValid,
        isSuccess: false,
      ),
    );
  }

  void _onDropdownChanged(
    CourierRequestDropdownChanged event,
    Emitter<CourierRequestState> emit,
  ) {
    final newDropdowns = {...state.dropdowns, event.field: event.value};
    final errors = _validate(
      state.fields,
      newDropdowns,
      state.touchedFields,
      state.isSubmitted,
    );
    emit(
      state.copyWith(
        dropdowns: newDropdowns,
        errors: errors,
        isFormValid: errors.isEmpty,
        isSuccess: false,
      ),
    );
  }

  Future<void> _onSubmit(
    CourierRequestSubmit event,
    Emitter<CourierRequestState> emit,
  ) async {
    final errors = _validate(
      state.fields,
      state.dropdowns,
      allCourierRequestFields.toSet(),
      true,
    );
    final isFormValid = errors.isEmpty;
    if (!isFormValid) {
      emit(
        state.copyWith(
          errors: errors,
          isFormValid: false,
          isSubmitting: false,
          isSuccess: false,
          touchedFields: allCourierRequestFields.toSet(),
          isSubmitted: true,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        isSubmitting: true,
        isSuccess: false,
        isSubmitted: true,
        touchedFields: allCourierRequestFields.toSet(),
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(state.copyWith(isSuccess: false));
  }

  String _calcPriority(dynamic deadline) {
    if (deadline is DateTime) {
      final now = DateTime.now();
      final diff = deadline.difference(now);
      if (diff.inHours < 24) {
        return 'Срочно';
      } else {
        return 'Обычный приоритет';
      }
    }
    return '';
  }

  Map<CourierRequestField, String?> _validate(
    Map<CourierRequestField, dynamic> fields,
    Map<CourierRequestField, dynamic> dropdowns,
    Set<CourierRequestField> activeFields,
    bool isSubmitted,
  ) {
    final errors = <CourierRequestField, String?>{};
    void req(CourierRequestField key, String label) {
      if (!activeFields.contains(key) && !isSubmitted) return;
      final value = fields[key];
      if (value == null || (value is String && value.trim().isEmpty)) {
        errors[key] = 'Обязательное поле';
      }
    }

    void reqRegionsOnly(CourierRequestField key, String label) {
      if (!activeFields.contains(key) && !isSubmitted) return;
      if (fields[CourierRequestField.deliveryType] ==
          CourierDeliveryType.regions) {
        final value = fields[key];
        if (value == null || (value is String && value.trim().isEmpty)) {
          errors[key] = 'Обязательное поле';
        }
      }
    }

    req(CourierRequestField.company, 'Юр. лицо');
    req(CourierRequestField.department, 'Подразделение');
    req(CourierRequestField.contactPhone, 'Телефон');
    req(CourierRequestField.companyName, 'Компания');
    req(CourierRequestField.address, 'Адрес');
    req(CourierRequestField.fio, 'ФИО');
    req(CourierRequestField.phone, 'Телефон');
    if (activeFields.contains(CourierRequestField.deadline) || isSubmitted) {
      if (fields[CourierRequestField.deadline] == null) {
        errors[CourierRequestField.deadline] = 'Обязательное поле';
      }
    }
    if (activeFields.contains(CourierRequestField.tripGoal) || isSubmitted) {
      if (dropdowns[CourierRequestField.tripGoal] == null) {
        errors[CourierRequestField.tripGoal] = 'Обязательное поле';
      }
    }
    if (activeFields.contains(CourierRequestField.office) || isSubmitted) {
      if (dropdowns[CourierRequestField.office] == null) {
        errors[CourierRequestField.office] = 'Обязательное поле';
      }
    }
    if (activeFields.contains(CourierRequestField.manager) || isSubmitted) {
      if (dropdowns[CourierRequestField.manager] == null) {
        errors[CourierRequestField.manager] = 'Обязательное поле';
      }
    }
    // Email (если не пустой, то проверка)
    if ((activeFields.contains(CourierRequestField.email) || isSubmitted)) {
      final email = fields[CourierRequestField.email] as String?;
      if (email != null && email.isNotEmpty) {
        final reg = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
        if (!reg.hasMatch(email)) {
          errors[CourierRequestField.email] = 'Введите корректный email';
        }
      }
    }
    // Комментарий: не требовать, если пусто
    if ((activeFields.contains(CourierRequestField.comment) || isSubmitted)) {
      if (fields[CourierRequestField.addComment] == true &&
          (fields[CourierRequestField.comment] as String?)?.isNotEmpty ==
              true) {
        // Можно добавить доп. валидацию, если нужно
      }
    }
    reqRegionsOnly(CourierRequestField.expReason, 'Обоснование выбора');
    reqRegionsOnly(CourierRequestField.contentDesc, 'Опись содержимого');
    return errors;
  }
}
