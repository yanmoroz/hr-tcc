import 'package:flutter/material.dart';
import 'absence_request_controllers.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/entities/requests/absence_request.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class AbsenceFieldsLateArrival extends StatelessWidget {
  final AbsenceRequestControllers controllers;
  final Map<AbsenceRequestField, dynamic> fields;
  final Map<AbsenceRequestField, String?> errors;
  final void Function(AbsenceRequestField, dynamic) onChanged;
  final Future<TimeOfDay?> Function(BuildContext, TimeOfDay?) onPickTime;

  const AbsenceFieldsLateArrival({
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
          hint: 'Дата',
          value: fields[AbsenceRequestField.date],
          errorText: errors[AbsenceRequestField.date],
          onChanged: (date) => onChanged(AbsenceRequestField.date, date),
        ),
        const Gap(16),
        AppTimePickerField(
          hint: 'Время прихода',
          controller: controllers.timeController,
          focusNode: controllers.timeFocus,
          value: fields[AbsenceRequestField.time],
          errorText: errors[AbsenceRequestField.time],
          onChanged: (picked) => onChanged(AbsenceRequestField.time, picked),
          enabled: true,
        ),
        const Gap(16),
        AppTextArea(
          hint: 'Причина',
          controller: controllers.reasonController,
          errorText: errors[AbsenceRequestField.reason],
          focusNode: controllers.reasonFocus,
          onChanged: (v) => onChanged(AbsenceRequestField.reason, v),
        ),
      ],
    );
  }
}
