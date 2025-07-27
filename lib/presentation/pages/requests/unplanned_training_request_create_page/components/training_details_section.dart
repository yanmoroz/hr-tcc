import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/presentation/pages/requests/unplanned_training_request_create_page/components/unplanned_training_request_controllers.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:flutter/services.dart';

class TrainingDetailsSection extends StatelessWidget {
  final Map<UnplannedTrainingRequestField, dynamic> fields;
  final Map<UnplannedTrainingRequestField, String?> errors;
  final UnplannedTrainingRequestControllers controllers;
  final void Function(UnplannedTrainingRequestField, dynamic) onChanged;
  const TrainingDetailsSection({
    super.key,
    required this.fields,
    required this.errors,
    required this.controllers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          hint: 'Стоимость',
          controller:
              controllers.textControllers[UnplannedTrainingRequestField.cost],
          focusNode: controllers.focusNodes[UnplannedTrainingRequestField.cost],
          onChanged: (v) => onChanged(UnplannedTrainingRequestField.cost, v),
          errorText: errors[UnplannedTrainingRequestField.cost],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const Gap(12),
        AppTextArea(
          hint: 'Цель обучения',
          controller:
              controllers.textControllers[UnplannedTrainingRequestField.goal],
          focusNode: controllers.focusNodes[UnplannedTrainingRequestField.goal],
          onChanged: (v) => onChanged(UnplannedTrainingRequestField.goal, v),
          errorText: errors[UnplannedTrainingRequestField.goal],
        ),
        const Gap(12),
        AppTextField(
          hint: 'Ссылка на курс',
          controller:
              controllers.textControllers[UnplannedTrainingRequestField
                  .courseLink],
          focusNode:
              controllers.focusNodes[UnplannedTrainingRequestField.courseLink],
          onChanged:
              (v) => onChanged(UnplannedTrainingRequestField.courseLink, v),
          errorText: errors[UnplannedTrainingRequestField.courseLink],
        ),
      ],
    );
  }
}
