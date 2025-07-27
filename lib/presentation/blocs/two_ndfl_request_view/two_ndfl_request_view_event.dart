part of 'two_ndfl_request_view_bloc.dart';

abstract class TwoNdflRequestViewEvent extends Equatable {
  const TwoNdflRequestViewEvent();
  @override
  List<Object?> get props => [];
}

class LoadTwoNdflRequestDetails extends TwoNdflRequestViewEvent {
  final String requestId;
  const LoadTwoNdflRequestDetails(this.requestId);
  @override
  List<Object?> get props => [requestId];
}

abstract class TwoNdflRequestViewState extends Equatable {
  const TwoNdflRequestViewState();
  @override
  List<Object?> get props => [];
}