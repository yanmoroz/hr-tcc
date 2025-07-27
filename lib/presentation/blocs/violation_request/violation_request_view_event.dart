part of 'violation_request_view_bloc.dart';

abstract class ViolationRequestViewEvent {}

class LoadViolationRequestDetails extends ViolationRequestViewEvent {
  final String id;
  LoadViolationRequestDetails(this.id);
}
