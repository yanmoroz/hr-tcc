part of 'business_trip_request_view_bloc.dart';

abstract class BusinessTripRequestViewEvent {}

class LoadBusinessTripRequestDetails extends BusinessTripRequestViewEvent {
  final String id;
  LoadBusinessTripRequestDetails(this.id);
}
