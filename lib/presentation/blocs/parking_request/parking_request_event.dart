part of 'parking_request_bloc.dart';

abstract class ParkingRequestEvent {}

class ParkingRequestFieldChanged extends ParkingRequestEvent {
  final ParkingRequestField field;
  final dynamic value;
  ParkingRequestFieldChanged(this.field, this.value);
}

class ParkingRequestSubmitted extends ParkingRequestEvent {}

class ParkingRequestReset extends ParkingRequestEvent {}

class ParkingRequestFieldBlurred extends ParkingRequestEvent {
  final ParkingRequestField field;
  ParkingRequestFieldBlurred(this.field);
}

class ParkingRequestLoadCarBrands extends ParkingRequestEvent {}
