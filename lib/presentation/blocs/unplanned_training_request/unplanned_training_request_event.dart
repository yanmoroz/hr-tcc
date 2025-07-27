part of 'unplanned_training_request_bloc.dart';

abstract class UnplannedTrainingRequestEvent extends Equatable {
  const UnplannedTrainingRequestEvent();

  @override
  List<Object?> get props => [];
}

class UnplannedTrainingFieldChanged extends UnplannedTrainingRequestEvent {
  final UnplannedTrainingRequestField field;
  final dynamic value;
  const UnplannedTrainingFieldChanged(this.field, this.value);

  @override
  List<Object?> get props => [field, value];
}

class UnplannedTrainingSubmit extends UnplannedTrainingRequestEvent {}

class UnplannedTrainingFieldBlurred extends UnplannedTrainingRequestEvent {
  final UnplannedTrainingRequestField field;
  const UnplannedTrainingFieldBlurred(this.field);

  @override
  List<Object?> get props => [field];
}
