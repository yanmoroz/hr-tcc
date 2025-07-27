import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/presentation/widgets/common/app_modal_selector/app_modal_selector.dart';

class ManagerApproverSection extends StatelessWidget {
  final Map<UnplannedTrainingRequestField, dynamic> fields;
  final Map<UnplannedTrainingRequestField, String?> errors;
  final void Function(UnplannedTrainingRequestField, dynamic) onChanged;
  const ManagerApproverSection({
    super.key,
    required this.fields,
    required this.errors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppModalSelector<String>(
          title: 'Руководитель',
          items: const ['manager1', 'manager2'],
          selected: fields[UnplannedTrainingRequestField.manager],
          itemLabel:
              (v) =>
                  v == 'manager1' ? 'ФИО руководителя 1' : 'ФИО руководителя 2',
          onSelected:
              (v) => onChanged(UnplannedTrainingRequestField.manager, v),
          errorText: errors[UnplannedTrainingRequestField.manager],
        ),
        const SizedBox(height: 12),
        AppModalSelector<String>(
          title: 'Согласующий',
          items: const ['approver1', 'approver2'],
          selected: fields[UnplannedTrainingRequestField.approver],
          itemLabel:
              (v) =>
                  v == 'approver1'
                      ? 'ФИО согласующего 1'
                      : 'ФИО согласующего 2',
          onSelected:
              (v) => onChanged(UnplannedTrainingRequestField.approver, v),
          errorText: errors[UnplannedTrainingRequestField.approver],
        ),
      ],
    );
  }
}
