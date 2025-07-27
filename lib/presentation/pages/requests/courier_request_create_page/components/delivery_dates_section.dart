import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/pages/requests/components/app_priority_card.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

class DeliveryDatesSection extends StatelessWidget {
  final TextEditingController priorityController;
  final Map<CourierRequestField, FocusNode> focusNodes;
  final Map<CourierRequestField, String?> errors;
  const DeliveryDatesSection({
    super.key,
    required this.priorityController,
    required this.focusNodes,
    required this.errors,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourierRequestBloc, CourierRequestState>(
      builder: (context, state) {
        final deadline =
            state.fields[CourierRequestField.deadline] as DateTime?;
        final deadlineRange =
            state.fields[CourierRequestField.deadlineRange] as DateTimeRange?;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Сроки доставки',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Gap(16),
            if (deadline != null) ...[
              AppPriorityCard(
                priority: state.fields[CourierRequestField.priority] ?? '',
              ),
              const Gap(16),
            ],
            AppDatePickerField(
              mode: AppDatePickerMode.single,
              hint: 'Срок',
              value: deadline,
              rangeValue: deadlineRange,
              onChanged:
                  (date) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(
                      CourierRequestField.deadline,
                      date,
                    ),
                  ),
              onRangeChanged:
                  (range) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(
                      CourierRequestField.deadlineRange,
                      range,
                    ),
                  ),
              errorText: errors[CourierRequestField.deadline],
            ),
            const Gap(4),
            const Text(
              'Заявка будет исполнена до 19:00',
              style: TextStyle(fontSize: 13, color: AppColors.gray700),
            ),
          ],
        );
      },
    );
  }
}
