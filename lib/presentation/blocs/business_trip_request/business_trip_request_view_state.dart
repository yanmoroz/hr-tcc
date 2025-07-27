part of 'business_trip_request_view_bloc.dart';

abstract class BusinessTripRequestViewState {
  const BusinessTripRequestViewState();
}

class BusinessTripRequestViewLoading extends BusinessTripRequestViewState {
  const BusinessTripRequestViewLoading();
}

class BusinessTripRequestViewLoaded extends BusinessTripRequestViewState {
  final BusinessTripRequest details;
  const BusinessTripRequestViewLoaded(this.details);
}

class BusinessTripRequestViewError extends BusinessTripRequestViewState {
  final String message;
  const BusinessTripRequestViewError(this.message);
}
