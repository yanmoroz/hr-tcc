import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/domain/usecases/fetch_courier_request_data_usecase.dart';

abstract class EmployeesEvent {}

class LoadEmployees extends EmployeesEvent {}

abstract class EmployeesState {}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoading extends EmployeesState {}

class EmployeesLoaded extends EmployeesState {
  final List<Employee> employees;
  EmployeesLoaded(this.employees);
}

class EmployeesError extends EmployeesState {
  final String message;
  EmployeesError(this.message);
}

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final FetchCourierRequestDataUseCase fetchEmployeesUseCase;
  EmployeesBloc(this.fetchEmployeesUseCase) : super(EmployeesInitial()) {
    on<LoadEmployees>((event, emit) async {
      emit(EmployeesLoading());
      try {
        final employees = await fetchEmployeesUseCase.fetchEmployees();
        emit(EmployeesLoaded(employees));
      } on Exception catch (e) {
        emit(EmployeesError(e.toString()));
      }
    });
  }
}
