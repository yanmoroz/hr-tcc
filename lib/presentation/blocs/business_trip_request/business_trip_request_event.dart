part of 'business_trip_request_bloc.dart';

enum BusinessTripRequestField {
  period,
  fromCity,
  toCity,
  account,
  purpose,
  activity,
  plannedEvents,
  coordinatorService,
  comment,
  participants,
  purposeDescription,
}

abstract class BusinessTripRequestEvent {}

class BusinessTripRequestFieldChanged extends BusinessTripRequestEvent {
  final BusinessTripRequestField field;
  final dynamic value;
  BusinessTripRequestFieldChanged(this.field, this.value);
}

class BusinessTripRequestFieldBlurred extends BusinessTripRequestEvent {
  final BusinessTripRequestField field;
  BusinessTripRequestFieldBlurred(this.field);
}

class BusinessTripRequestSubmitted extends BusinessTripRequestEvent {}

class BusinessTripRequestReset extends BusinessTripRequestEvent {}

class BusinessTripRequestLoadEmployees extends BusinessTripRequestEvent {}
