part of 'two_ndfl_request_view_bloc.dart';

class TwoNdflRequestViewLoading extends TwoNdflRequestViewState {}

class TwoNdflRequestViewError extends TwoNdflRequestViewState {
  final String message;
  const TwoNdflRequestViewError(this.message);
  @override
  List<Object?> get props => [message];
}

class TwoNdflRequestViewLoaded extends TwoNdflRequestViewState {
  final TwoNdflRequestDetails details;
  const TwoNdflRequestViewLoaded(this.details);
  @override
  List<Object?> get props => [details];
}