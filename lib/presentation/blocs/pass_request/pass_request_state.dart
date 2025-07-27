part of 'pass_request_bloc.dart';

class PassRequestState {
  final Map<PassRequestField, dynamic> fields;
  final Map<PassRequestField, String?> errors;
  final bool loading;
  final bool success;
  final bool submitted;

  PassRequestState({
    required this.fields,
    required this.errors,
    required this.loading,
    required this.success,
    required this.submitted,
  });

  factory PassRequestState.initial() => PassRequestState(
    fields: {
      PassRequestField.type: PassType.guest,
      PassRequestField.legalEntity: null,
      PassRequestField.purpose: PassPurpose.meeting,
      PassRequestField.office: offices.first,
      PassRequestField.floor: offices.first.floors.first,
      PassRequestField.date: null,
      PassRequestField.timeFrom: null,
      PassRequestField.timeTo: null,
      PassRequestField.visitors: <dynamic>[],
      PassRequestField.otherPurpose: null,
      PassRequestField.dateOfStart: null,
      PassRequestField.photo: null,
      PassRequestField.entryPoint: null,
      PassRequestField.workRooms: '',
      PassRequestField.equipmentList: '',
    },
    errors: {},
    loading: false,
    success: false,
    submitted: false,
  );

  PassRequestState copyWith({
    Map<PassRequestField, dynamic>? fields,
    Map<PassRequestField, String?>? errors,
    bool? loading,
    bool? success,
    bool? submitted,
  }) {
    return PassRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      loading: loading ?? this.loading,
      success: success ?? this.success,
      submitted: submitted ?? this.submitted,
    );
  }

  Map<PassRequestField, String?> validate(
    Map<PassRequestField, dynamic> fields,
  ) {
    final errors = <PassRequestField, String?>{};
    if (fields[PassRequestField.type] == null) {
      errors[PassRequestField.type] = 'Обязательное поле';
    }
    if (fields[PassRequestField.legalEntity] == null) {
      errors[PassRequestField.legalEntity] = 'Обязательное поле';
    }
    if (fields[PassRequestField.type] == PassType.permanent) {
      if (fields[PassRequestField.visitors] == null ||
          (fields[PassRequestField.visitors] as List).length != 1) {
        errors[PassRequestField.visitors] = 'Добавьте одного сотрудника';
      }
      if (fields[PassRequestField.dateOfStart] == null) {
        errors[PassRequestField.dateOfStart] = 'Укажите дату выхода';
      }
      if (fields[PassRequestField.photo] == null) {
        errors[PassRequestField.photo] = 'Добавьте фото';
      }
    }
    if (fields[PassRequestField.type] == PassType.overtime ||
        fields[PassRequestField.type] == PassType.contractor) {
      if (fields[PassRequestField.entryPoint] == null) {
        errors[PassRequestField.entryPoint] = 'Выберите вход';
      }
      if (fields[PassRequestField.otherPurpose] == null ||
          (fields[PassRequestField.otherPurpose] as String).trim().isEmpty) {
        errors[PassRequestField.otherPurpose] = 'Укажите цель посещения';
      }
      if (fields[PassRequestField.type] == PassType.contractor) {
        if (fields[PassRequestField.workRooms] == null ||
            (fields[PassRequestField.workRooms] as String).trim().isEmpty) {
          errors[PassRequestField.workRooms] =
              'Укажите помещения проведения работ';
        }
        if (fields[PassRequestField.equipmentList] == null ||
            (fields[PassRequestField.equipmentList] as String).trim().isEmpty) {
          errors[PassRequestField.equipmentList] =
              'Укажите список оборудования';
        }
      }
    } else {
      if (fields[PassRequestField.purpose] == null) {
        errors[PassRequestField.purpose] = 'Обязательное поле';
      }
      if (fields[PassRequestField.purpose] == PassPurpose.other &&
          (fields[PassRequestField.otherPurpose] == null ||
              (fields[PassRequestField.otherPurpose] as String)
                  .trim()
                  .isEmpty)) {
        errors[PassRequestField.otherPurpose] = 'Укажите цель';
      }
    }
    // Проверка на пустые ФИО
    final visitors = fields[PassRequestField.visitors] as List?;
    if (visitors != null &&
        visitors.any((v) => v is String && v.trim().isEmpty)) {
      errors[PassRequestField.visitors] = 'Заполните все ФИО';
    }
    // Валидация времени
    final from = fields[PassRequestField.timeFrom];
    final to = fields[PassRequestField.timeTo];
    if (from != null && to != null) {
      final fromMinutes = from.hour * 60 + from.minute;
      final toMinutes = to.hour * 60 + to.minute;
      if (toMinutes <= fromMinutes) {
        errors[PassRequestField.timeTo] = 'Некорректное время';
      }
    }
    return errors;
  }

  bool get isFormValid => validate(fields).isEmpty;
}
