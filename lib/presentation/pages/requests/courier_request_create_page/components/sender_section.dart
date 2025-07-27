import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

class SenderSection extends StatelessWidget {
  final TextEditingController companyController;
  final TextEditingController departmentController;
  final TextEditingController contactPhoneController;
  final Map<CourierRequestField, FocusNode> focusNodes;
  final Map<CourierRequestField, String?> errors;
  const SenderSection({
    super.key,
    required this.companyController,
    required this.departmentController,
    required this.contactPhoneController,
    required this.focusNodes,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourierRequestBloc, CourierRequestState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'От кого доставка',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Gap(16),
            AppTextField(
              hint: 'Юридическое лицо',
              controller: companyController,
              focusNode: focusNodes[CourierRequestField.company],
              onChanged:
                  (v) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(CourierRequestField.company, v),
                  ),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Обязательное поле'
                          : null,
              errorText: errors[CourierRequestField.company],
            ),
            const Gap(16),
            AppTextField(
              hint: 'Подразделение',
              controller: departmentController,
              focusNode: focusNodes[CourierRequestField.department],
              onChanged:
                  (v) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(
                      CourierRequestField.department,
                      v,
                    ),
                  ),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Обязательное поле'
                          : null,
              errorText: errors[CourierRequestField.department],
            ),
            const Gap(16),
            AppTextField(
              hint: 'Контактный телефон',
              controller: contactPhoneController,
              focusNode: focusNodes[CourierRequestField.contactPhone],
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\+\s\-]')),
                LengthLimitingTextInputFormatter(16),
              ],
              onChanged:
                  (v) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(
                      CourierRequestField.contactPhone,
                      v,
                    ),
                  ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Обязательное поле';
                // Можно добавить более строгую проверку
                return null;
              },
              errorText: errors[CourierRequestField.contactPhone],
            ),
            const Gap(16),
            AppModalSelector<TripGoal>(
              title: 'Цель поездки',
              items: state.tripGoals,
              selected: state.dropdowns[CourierRequestField.tripGoal],
              itemLabel: (g) => g.name,
              onSelected:
                  (g) => context.read<CourierRequestBloc>().add(
                    CourierRequestDropdownChanged(
                      CourierRequestField.tripGoal,
                      g,
                    ),
                  ),
              errorText: errors[CourierRequestField.tripGoal],
            ),
            const Gap(16),
            AppModalSelector<Office>(
              title: 'Офис',
              items: state.offices,
              selected: state.dropdowns[CourierRequestField.office],
              itemLabel: (o) => o.name,
              onSelected:
                  (o) => context.read<CourierRequestBloc>().add(
                    CourierRequestDropdownChanged(
                      CourierRequestField.office,
                      o,
                    ),
                  ),
              errorText: errors[CourierRequestField.office],
            ),
            const Gap(4),
            const Text(
              'Сотрудник из «Федерации» выбирает «Око»',
              style: TextStyle(fontSize: 13, color: AppColors.gray700),
            ),
            if (state.deliveryType == CourierDeliveryType.regions) ...[
              const Gap(16),
              AppModalSelector<Employee>(
                title: 'Руководитель',
                items: state.employees,
                selected: state.dropdowns[CourierRequestField.manager],
                itemLabel: (m) => m.fullName,
                subtitleLabel: (m) => m.role,
                onSelected:
                    (m) => context.read<CourierRequestBloc>().add(
                      CourierRequestDropdownChanged(
                        CourierRequestField.manager,
                        m,
                      ),
                    ),
                searchHint: 'ФИО',
                errorText: errors[CourierRequestField.manager],
              ),
            ],
          ],
        );
      },
    );
  }
}
