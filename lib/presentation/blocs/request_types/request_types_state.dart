part of 'request_types_bloc.dart';

abstract class RequestTypesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestTypesInitial extends RequestTypesState {}

class RequestTypesLoading extends RequestTypesState {}

class RequestTypesLoaded extends RequestTypesState {
  final List<RequestTypeInfo> types;
  RequestTypesLoaded({required this.types});
  @override
  List<Object?> get props => [types];
}

class RequestTypesError extends RequestTypesState {
  final String message;
  RequestTypesError(this.message);
  @override
  List<Object?> get props => [message];
}
