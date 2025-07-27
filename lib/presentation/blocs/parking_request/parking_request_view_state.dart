part of 'parking_request_view_bloc.dart';

abstract class ParkingRequestViewState {}

class ParkingRequestViewInitial extends ParkingRequestViewState {}

class ParkingRequestViewLoading extends ParkingRequestViewState {}

class ParkingRequestViewLoaded extends ParkingRequestViewState {
  final ParkingRequest details;
  ParkingRequestViewLoaded(this.details);
}

class ParkingRequestViewError extends ParkingRequestViewState {
  final String message;
  ParkingRequestViewError(this.message);
}
