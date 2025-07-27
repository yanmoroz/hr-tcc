import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/parking_request.dart';
import 'package:hr_tcc/domain/usecases/create_parking_request_usecase.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:hr_tcc/domain/usecases/get_car_brands_usecase.dart';
import 'package:hr_tcc/domain/entities/pass_request.dart';

part 'parking_request_event.dart';
part 'parking_request_state.dart';

class ParkingRequestBloc
    extends Bloc<ParkingRequestEvent, ParkingRequestState> {
  final CreateParkingRequestUseCase createUseCase;
  final GetCarBrandsUseCase getCarBrandsUseCase;
  ParkingRequestBloc(this.createUseCase, this.getCarBrandsUseCase)
    : super(ParkingRequestState.initial()) {
    on<ParkingRequestFieldChanged>(_onFieldChanged);
    on<ParkingRequestFieldBlurred>(_onFieldBlurred);
    on<ParkingRequestSubmitted>(_onSubmitted);
    on<ParkingRequestReset>(_onReset);
    on<ParkingRequestLoadCarBrands>(_onLoadCarBrands);
  }

  void _onFieldChanged(
    ParkingRequestFieldChanged event,
    Emitter<ParkingRequestState> emit,
  ) {
    final newFields = Map<ParkingRequestField, dynamic>.from(state.fields);
    newFields[event.field] = event.value;
    final newErrors = state.validate(newFields);
    emit(state.copyWith(fields: newFields, errors: newErrors));
  }

  void _onFieldBlurred(
    ParkingRequestFieldBlurred event,
    Emitter<ParkingRequestState> emit,
  ) {
    final newErrors = Map<ParkingRequestField, String?>.from(state.errors);
    final value = state.fields[event.field];
    final requiredFields = [
      ParkingRequestField.type,
      ParkingRequestField.purpose,
      ParkingRequestField.office,
      ParkingRequestField.floor,
      ParkingRequestField.carBrand,
      ParkingRequestField.carNumber,
      ParkingRequestField.date,
      ParkingRequestField.timeFrom,
      ParkingRequestField.timeTo,
      ParkingRequestField.visitors,
    ];
    // purposeText только для guest/cargo
    if ((state.fields[ParkingRequestField.type] == ParkingType.guest ||
            state.fields[ParkingRequestField.type] == ParkingType.cargo) &&
        event.field == ParkingRequestField.purposeText) {
      if (value == null || (value is String && value.trim().isEmpty)) {
        newErrors[event.field] = 'Обязательное поле';
      } else {
        newErrors.remove(event.field);
      }
    }
    if (requiredFields.contains(event.field)) {
      if (value == null ||
          (value is String && value.trim().isEmpty) ||
          (value is List && value.isEmpty)) {
        newErrors[event.field] = 'Обязательное поле';
      } else {
        newErrors.remove(event.field);
      }
    }
    emit(state.copyWith(errors: newErrors));
  }

  Future<void> _onSubmitted(
    ParkingRequestSubmitted event,
    Emitter<ParkingRequestState> emit,
  ) async {
    final errors = state.validate(state.fields);
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors, submitted: true));
      return;
    }
    emit(state.copyWith(loading: true));
    final fields = state.fields;
    final request = ParkingRequest(
      id: UniqueKey().toString(),
      type: fields[ParkingRequestField.type],
      purpose: fields[ParkingRequestField.purpose],
      floor: fields[ParkingRequestField.floor],
      office: fields[ParkingRequestField.office],
      carBrand: fields[ParkingRequestField.carBrand],
      carNumber: fields[ParkingRequestField.carNumber],
      dateRange: fields[ParkingRequestField.date],
      timeFrom: fields[ParkingRequestField.timeFrom],
      timeTo: fields[ParkingRequestField.timeTo],
      visitors: fields[ParkingRequestField.visitors],
      parkingPlaceNumber: fields[ParkingRequestField.parkingPlaceNumber],
      purposeText: fields[ParkingRequestField.purposeText],
      cargoReason: fields[ParkingRequestField.cargoReason],
      cargoDescription: fields[ParkingRequestField.cargoDescription],
      driver: fields[ParkingRequestField.driver],
      escort: fields[ParkingRequestField.escort],
      liftAction: fields[ParkingRequestField.liftAction],
      liftNumber: fields[ParkingRequestField.liftNumber],
      status: RequestStatus.newRequest,
      createdAt: DateTime.now(),
    );
    await createUseCase(request);
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(loading: false, success: true));
  }

  Future<void> _onLoadCarBrands(
    ParkingRequestLoadCarBrands event,
    Emitter<ParkingRequestState> emit,
  ) async {
    emit(state.copyWith(carBrandsLoading: true, carBrandsError: null));
    try {
      final brands = await getCarBrandsUseCase();
      emit(state.copyWith(carBrands: brands, carBrandsLoading: false));
    } on Exception catch (e) {
      emit(
        state.copyWith(carBrandsLoading: false, carBrandsError: e.toString()),
      );
    }
  }

  void _onReset(ParkingRequestReset event, Emitter<ParkingRequestState> emit) {
    emit(ParkingRequestState.initial());
  }
}
