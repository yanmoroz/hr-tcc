import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

abstract class EmployeeListEvent {}

class EmployeeAdded extends EmployeeListEvent {
  final Employee employee;
  EmployeeAdded(this.employee);
}

class EmployeeRemoved extends EmployeeListEvent {
  final Employee employee;
  EmployeeRemoved(this.employee);
}

class EmployeeListReplaced extends EmployeeListEvent {
  final List<Employee> employees;
  EmployeeListReplaced(this.employees);
}

class EmployeeListState {
  final List<Employee> selected;
  EmployeeListState(this.selected);
}

class EmployeeListBloc extends Bloc<EmployeeListEvent, EmployeeListState> {
  EmployeeListBloc(List<Employee> initial)
    : super(EmployeeListState(initial.isNotEmpty ? [initial.first] : [])) {
    on<EmployeeAdded>((event, emit) {
      if (!state.selected.contains(event.employee)) {
        emit(EmployeeListState([...state.selected, event.employee]));
      }
    });
    on<EmployeeRemoved>((event, emit) {
      final updated = [...state.selected]..remove(event.employee);
      if (updated.isEmpty) {
        emit(state);
      } else {
        emit(EmployeeListState(updated));
      }
    });
    on<EmployeeListReplaced>((event, emit) {
      emit(EmployeeListState(event.employees));
    });
  }
}
