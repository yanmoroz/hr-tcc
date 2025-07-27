import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/presentation/pages/requests/unplanned_training_request_create_page/components/unplanned_training_request_controllers.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class TrainingMainSection extends StatelessWidget {
  final Map<UnplannedTrainingRequestField, dynamic> fields;
  final Map<UnplannedTrainingRequestField, String?> errors;
  final UnplannedTrainingRequestControllers controllers;
  final void Function(UnplannedTrainingRequestField, dynamic) onChanged;
  const TrainingMainSection({
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
        Text('Обучение', style: AppTypography.title3Semibold),
        const Gap(12),
        AppModalSelector<UnplannedTrainingOrganizer>(
          title: 'Организатор',
          items: UnplannedTrainingOrganizer.values,
          selected: fields[UnplannedTrainingRequestField.organizer],
          itemLabel: (e) => e.label,
          onSelected:
              (v) => onChanged(UnplannedTrainingRequestField.organizer, v),
          errorText: errors[UnplannedTrainingRequestField.organizer],
        ),
        if (fields[UnplannedTrainingRequestField.organizer] ==
            UnplannedTrainingOrganizer.other) ...[
          const Gap(12),
          AppTextField(
            hint: 'Название организатора',
            controller:
                controllers.textControllers[UnplannedTrainingRequestField
                    .organizerName],
            focusNode:
                controllers.focusNodes[UnplannedTrainingRequestField
                    .organizerName],
            onChanged:
                (v) =>
                    onChanged(UnplannedTrainingRequestField.organizerName, v),
            errorText: errors[UnplannedTrainingRequestField.organizerName],
          ),
        ],
        const Gap(12),
        AppTextField(
          hint: 'Название мероприятия',
          controller:
              controllers.textControllers[UnplannedTrainingRequestField
                  .eventName],
          focusNode:
              controllers.focusNodes[UnplannedTrainingRequestField.eventName],
          onChanged:
              (v) => onChanged(UnplannedTrainingRequestField.eventName, v),
          errorText: errors[UnplannedTrainingRequestField.eventName],
        ),
        const Gap(12),
        AppModalSelector<UnplannedTrainingType>(
          title: 'Вид',
          items: UnplannedTrainingType.values,
          selected: fields[UnplannedTrainingRequestField.type],
          itemLabel: (e) => e.label,
          onSelected: (v) => onChanged(UnplannedTrainingRequestField.type, v),
          errorText: errors[UnplannedTrainingRequestField.type],
        ),
        const Gap(12),
        AppModalSelector<UnplannedTrainingForm>(
          title: 'Форма',
          items: UnplannedTrainingForm.values,
          selected: fields[UnplannedTrainingRequestField.form],
          itemLabel: (e) => e.label,
          onSelected: (v) => onChanged(UnplannedTrainingRequestField.form, v),
          errorText: errors[UnplannedTrainingRequestField.form],
        ),
        const Gap(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppDatePickerField(
                hint: 'Дата начала',
                value: fields[UnplannedTrainingRequestField.startDate],
                onChanged:
                    (v) =>
                        onChanged(UnplannedTrainingRequestField.startDate, v),
                errorText: errors[UnplannedTrainingRequestField.startDate],
                enabled:
                    fields[UnplannedTrainingRequestField.unknownDates] != true,
              ),
            ),
            const Gap(12),
            Expanded(
              child: AppDatePickerField(
                hint: 'Дата окончания',
                value: fields[UnplannedTrainingRequestField.endDate],
                onChanged:
                    (v) => onChanged(UnplannedTrainingRequestField.endDate, v),
                errorText: errors[UnplannedTrainingRequestField.endDate],
                enabled:
                    fields[UnplannedTrainingRequestField.unknownDates] != true,
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            Text('Точные даты неизвестны', style: AppTypography.text1Medium),
            const Spacer(),
            AppSwitch(
              value: fields[UnplannedTrainingRequestField.unknownDates] == true,
              onChanged:
                  (v) =>
                      onChanged(UnplannedTrainingRequestField.unknownDates, v),
            ),
          ],
        ),
        if (fields[UnplannedTrainingRequestField.unknownDates] == true) ...[
          const Gap(12),
          AppModalSelector<UnplannedTrainingMonth>(
            title: 'Месяц',
            items: UnplannedTrainingMonth.values,
            selected: fields[UnplannedTrainingRequestField.month],
            itemLabel: (m) => m.label,
            onSelected:
                (v) => onChanged(UnplannedTrainingRequestField.month, v),
            errorText: errors[UnplannedTrainingRequestField.month],
          ),
        ],
      ],
    );
  }
}
