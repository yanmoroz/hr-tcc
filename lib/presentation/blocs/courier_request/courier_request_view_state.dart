part of 'courier_request_view_bloc.dart';

abstract class CourierRequestViewState {}

class CourierRequestDetailsInitial extends CourierRequestViewState {}

class CourierRequestDetailsLoading extends CourierRequestViewState {}

class CourierRequestDetailsLoaded extends CourierRequestViewState {
  final CourierRequestDetails details;
  CourierRequestDetailsLoaded(this.details);
}

class CourierRequestDetailsError extends CourierRequestViewState {
  final String message;
  CourierRequestDetailsError(this.message);
}
