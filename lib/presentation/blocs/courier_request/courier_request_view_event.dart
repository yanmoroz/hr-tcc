part of 'courier_request_view_bloc.dart';

abstract class CourierRequestViewEvent {}

class LoadCourierRequestDetails extends CourierRequestViewEvent {
  final String id;
  LoadCourierRequestDetails(this.id);
}
