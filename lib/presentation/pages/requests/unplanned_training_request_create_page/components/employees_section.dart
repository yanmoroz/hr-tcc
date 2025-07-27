import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/presentation/widgets/common/employee_list_selector/employee_list_selector.dart';
import 'package:hr_tcc/presentation/blocs/employees/employees_bloc.dart';

class EmployeesSection extends StatelessWidget {
  final Map<UnplannedTrainingRequestField, dynamic> fields;
  final Map<UnplannedTrainingRequestField, String?> errors;
  final EmployeesState empState;
  final void Function(UnplannedTrainingRequestField, dynamic) onChanged;
  const EmployeesSection({
    super.key,
    required this.fields,
    required this.errors,
    required this.empState,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (empState is EmployeesLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (empState is EmployeesError) {
      return Text(
        'Ошибка загрузки сотрудников: ${(empState as EmployeesError).message}',
      );
    } else if (empState is EmployeesLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmployeeListSelector<Employee>(
            title: 'Обучающиеся',
            addButtonText: 'Добавить обучающихся',
            allEmployees: (empState as EmployeesLoaded).employees,
            selectedEmployees:
                (fields[UnplannedTrainingRequestField.employees]
                    as List<Employee>?) ??
                [],
            itemLabel: (e) => e.fullName,
            subtitleLabel: (e) => e.role,
            onAdd: (e) {
              final current = List<Employee>.from(
                fields[UnplannedTrainingRequestField.employees] ?? [],
              );
              current.add(e);
              onChanged(UnplannedTrainingRequestField.employees, current);
            },
            onRemove: (e) {
              final current = List<Employee>.from(
                fields[UnplannedTrainingRequestField.employees] ?? [],
              );
              current.remove(e);
              onChanged(UnplannedTrainingRequestField.employees, current);
            },
            errorText: errors[UnplannedTrainingRequestField.employees],
            multiple: true,
            maxCount: 5,
            onChanged:
                (list) =>
                    onChanged(UnplannedTrainingRequestField.employees, list),
          ),
          if (errors[UnplannedTrainingRequestField.employees] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                errors[UnplannedTrainingRequestField.employees]!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
