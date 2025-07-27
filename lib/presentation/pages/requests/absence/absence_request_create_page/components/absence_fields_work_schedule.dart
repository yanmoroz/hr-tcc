import 'package:flutter/material.dart';
import 'absence_request_controllers.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/entities/requests/absence_request.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class AbsenceFieldsWorkSchedule extends StatelessWidget {
  final AbsenceRequestControllers controllers;
  final Map<AbsenceRequestField, dynamic> fields;
  final Map<AbsenceRequestField, String?> errors;
  final void Function(AbsenceRequestField, dynamic) onChanged;
  final Future<TimeOfDay?> Function(BuildContext, TimeOfDay?) onPickTime;

  const AbsenceFieldsWorkSchedule({
    super.key,
    required this.controllers,
    required this.fields,
    required this.errors,
    required this.onChanged,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDatePickerField(
          hint: 'Дата или период',
          rangeValue: fields[AbsenceRequestField.period],
          mode: AppDatePickerMode.range,
          errorText: errors[AbsenceRequestField.period],
          onRangeChanged:
              (range) => onChanged(AbsenceRequestField.period, range),
        ),
        const Gap(16),
        AppTimePickerField(
          hint: 'График работы, часы «С»',
          controller: controllers.timeRangeStartController,
          focusNode: controllers.timeRangeStartFocus,
          value: fields[AbsenceRequestField.timeRangeStart],
          errorText: errors[AbsenceRequestField.timeRangeStart],
          onChanged:
              (picked) => onChanged(AbsenceRequestField.timeRangeStart, picked),
          enabled: true,
        ),
        const Gap(16),
        AppTimePickerField(
          hint: 'График работы, часы «До»',
          controller: controllers.timeRangeEndController,
          focusNode: controllers.timeRangeEndFocus,
          value: fields[AbsenceRequestField.timeRangeEnd],
          errorText: errors[AbsenceRequestField.timeRangeEnd],
          onChanged:
              (picked) => onChanged(AbsenceRequestField.timeRangeEnd, picked),
          enabled: true,
        ),
        const Gap(16),
        AppTextArea(
          hint: 'Причина',
          controller: controllers.reasonController,
          errorText: errors[AbsenceRequestField.reason],
          onChanged: (v) => onChanged(AbsenceRequestField.reason, v),
        ),
      ],
    );
  }
}
