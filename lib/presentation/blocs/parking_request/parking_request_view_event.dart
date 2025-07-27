part of 'parking_request_view_bloc.dart';

abstract class ParkingRequestViewEvent {}

class LoadParkingRequestDetails extends ParkingRequestViewEvent {
  final String id;
  LoadParkingRequestDetails(this.id);
}
