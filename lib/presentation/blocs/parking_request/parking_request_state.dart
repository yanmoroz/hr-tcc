part of 'parking_request_bloc.dart';

class ParkingRequestState {
  final Map<ParkingRequestField, dynamic> fields;
  final Map<ParkingRequestField, String?> errors;
  final bool loading;
  final bool success;
  final bool submitted;
  final List<String> carBrands;
  final bool carBrandsLoading;
  final String? carBrandsError;

  ParkingRequestState({
    required this.fields,
    required this.errors,
    required this.loading,
    required this.success,
    required this.submitted,
    required this.carBrands,
    required this.carBrandsLoading,
    required this.carBrandsError,
  });

  factory ParkingRequestState.initial() => ParkingRequestState(
    fields: {
      ParkingRequestField.type: ParkingType.guest,
      ParkingRequestField.purpose: PassPurpose.meeting,
      ParkingRequestField.office: null,
      ParkingRequestField.floor: null,
      ParkingRequestField.carBrand: '',
      ParkingRequestField.carNumber: '',
      ParkingRequestField.date: null,
      ParkingRequestField.timeFrom: null,
      ParkingRequestField.timeTo: null,
      ParkingRequestField.visitors: <String>[],
      ParkingRequestField.parkingPlaceNumber: '',
      ParkingRequestField.purposeText: '',
      ParkingRequestField.cargoReason: '',
      ParkingRequestField.cargoDescription: '',
      ParkingRequestField.driver: '',
      ParkingRequestField.escort: '',
      ParkingRequestField.liftAction: '',
      ParkingRequestField.liftNumber: null,
    },
    errors: {},
    loading: false,
    success: false,
    submitted: false,
    carBrands: const [],
    carBrandsLoading: false,
    carBrandsError: null,
  );

  ParkingRequestState copyWith({
    Map<ParkingRequestField, dynamic>? fields,
    Map<ParkingRequestField, String?>? errors,
    bool? loading,
    bool? success,
    bool? submitted,
    List<String>? carBrands,
    bool? carBrandsLoading,
    String? carBrandsError,
  }) {
    return ParkingRequestState(
      fields: fields ?? this.fields,
      errors: errors ?? this.errors,
      loading: loading ?? this.loading,
      success: success ?? this.success,
      submitted: submitted ?? this.submitted,
      carBrands: carBrands ?? this.carBrands,
      carBrandsLoading: carBrandsLoading ?? this.carBrandsLoading,
      carBrandsError: carBrandsError ?? this.carBrandsError,
    );
  }

  bool get isFormValid => validate(fields).isEmpty;

  Map<ParkingRequestField, String?> validate(
    Map<ParkingRequestField, dynamic> fields,
  ) {
    final errors = <ParkingRequestField, String?>{};
    if (fields[ParkingRequestField.type] == null) {
      errors[ParkingRequestField.type] = 'Обязательное поле';
    }
    if (fields[ParkingRequestField.purpose] == null) {
      errors[ParkingRequestField.purpose] = 'Обязательное поле';
    }
    if (fields[ParkingRequestField.office] == null) {
      errors[ParkingRequestField.office] = 'Обязательное поле';
    }
    if (fields[ParkingRequestField.floor] == null) {
      errors[ParkingRequestField.floor] = 'Обязательное поле';
    }
    if ((fields[ParkingRequestField.carBrand] as String).trim().isEmpty) {
      errors[ParkingRequestField.carBrand] = 'Обязательное поле';
    }
    if ((fields[ParkingRequestField.carNumber] as String).trim().isEmpty) {
      errors[ParkingRequestField.carNumber] = 'Обязательное поле';
    }
    if (fields[ParkingRequestField.date] == null) {
      errors[ParkingRequestField.date] = 'Обязательное поле';
    }
    if (fields[ParkingRequestField.timeFrom] == null) {
      errors[ParkingRequestField.timeFrom] = 'Обязательное поле';
    }
    if (fields[ParkingRequestField.timeTo] == null) {
      errors[ParkingRequestField.timeTo] = 'Обязательное поле';
    }
    final visitors = fields[ParkingRequestField.visitors] as List?;
    if (visitors == null || visitors.isEmpty) {
      errors[ParkingRequestField.visitors] =
          'Добавьте хотя бы одного посетителя';
    } else if (visitors.any((v) => v is String && v.trim().isEmpty)) {
      errors[ParkingRequestField.visitors] = 'Заполните все ФИО';
    }
    if (fields[ParkingRequestField.type] == ParkingType.reserved &&
        (fields[ParkingRequestField.parkingPlaceNumber] as String)
            .trim()
            .isEmpty) {
      errors[ParkingRequestField.parkingPlaceNumber] = 'Обязательное поле';
    }
    if ((fields[ParkingRequestField.type] == ParkingType.guest ||
        fields[ParkingRequestField.type] == ParkingType.cargo)) {
      if ((fields[ParkingRequestField.purposeText] as String).trim().isEmpty) {
        errors[ParkingRequestField.purposeText] = 'Обязательное поле';
      }
    }
    if (fields[ParkingRequestField.type] == ParkingType.cargo) {
      if ((fields[ParkingRequestField.cargoReason] as String).trim().isEmpty) {
        errors[ParkingRequestField.cargoReason] = 'Обязательное поле';
      }
      if ((fields[ParkingRequestField.cargoDescription] as String)
          .trim()
          .isEmpty) {
        errors[ParkingRequestField.cargoDescription] = 'Обязательное поле';
      }
      if ((fields[ParkingRequestField.driver] as String).trim().isEmpty) {
        errors[ParkingRequestField.driver] = 'Обязательное поле';
      }
      if ((fields[ParkingRequestField.escort] as String).trim().isEmpty) {
        errors[ParkingRequestField.escort] = 'Обязательное поле';
      }
      if ((fields[ParkingRequestField.liftAction] as String).trim().isEmpty) {
        errors[ParkingRequestField.liftAction] = 'Обязательное поле';
      }
      if (fields[ParkingRequestField.liftNumber] == null) {
        errors[ParkingRequestField.liftNumber] = 'Обязательное поле';
      }
    }
    return errors;
  }
}
