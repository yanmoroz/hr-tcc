part of 'unplanned_training_request_view_bloc.dart';

abstract class UnplannedTrainingRequestViewState {}

class UnplannedTrainingRequestViewLoading
    extends UnplannedTrainingRequestViewState {}

class UnplannedTrainingRequestViewLoaded
    extends UnplannedTrainingRequestViewState {
  final UnplannedTrainingRequest request;
  UnplannedTrainingRequestViewLoaded(this.request);
}

class UnplannedTrainingRequestViewError
    extends UnplannedTrainingRequestViewState {
  final String message;
  UnplannedTrainingRequestViewError(this.message);
}
