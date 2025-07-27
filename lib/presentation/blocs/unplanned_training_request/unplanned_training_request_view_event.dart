part of 'unplanned_training_request_view_bloc.dart';

abstract class UnplannedTrainingRequestViewEvent {}

class LoadUnplannedTrainingRequestDetails
    extends UnplannedTrainingRequestViewEvent {
  final String id;
  LoadUnplannedTrainingRequestDetails(this.id);
}
