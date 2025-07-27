part of 'two_ndfl_request_bloc.dart';

abstract class TwoNdflRequestEvent extends Equatable {
  const TwoNdflRequestEvent();
  @override
  List<Object?> get props => [];
}

class TwoNdflRequestFieldChanged extends TwoNdflRequestEvent {
  final TwoNdflRequestField field;
  final dynamic value;
  const TwoNdflRequestFieldChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class TwoNdflRequestFieldBlurred extends TwoNdflRequestEvent {
  final TwoNdflRequestField field;
  const TwoNdflRequestFieldBlurred(this.field);
  @override
  List<Object?> get props => [field];
}

class TwoNdflRequestSubmit extends TwoNdflRequestEvent {}
