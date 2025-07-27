import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

class ReceiverSection extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController addressController;
  final TextEditingController fioController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final Map<CourierRequestField, FocusNode> focusNodes;
  final Map<CourierRequestField, String?> errors;
  const ReceiverSection({
    super.key,
    required this.companyNameController,
    required this.addressController,
    required this.fioController,
    required this.phoneController,
    required this.emailController,
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
              'Куда и кому доставить',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Gap(16),
            AppTextField(
              hint: 'Наименование компании',
              controller: companyNameController,
              focusNode: focusNodes[CourierRequestField.companyName],
              onChanged:
                  (v) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(
                      CourierRequestField.companyName,
                      v,
                    ),
                  ),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Обязательное поле'
                          : null,
              errorText: errors[CourierRequestField.companyName],
            ),
            const Gap(16),
            AppTextField(
              hint: 'Адрес',
              controller: addressController,
              focusNode: focusNodes[CourierRequestField.address],
              onChanged:
                  (v) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(CourierRequestField.address, v),
                  ),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Обязательное поле'
                          : null,
              errorText: errors[CourierRequestField.address],
            ),
            const Gap(16),
            AppTextField(
              hint: 'ФИО',
              controller: fioController,
              focusNode: focusNodes[CourierRequestField.fio],
              onChanged:
                  (v) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(CourierRequestField.fio, v),
                  ),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Обязательное поле'
                          : null,
              errorText: errors[CourierRequestField.fio],
            ),
            const Gap(16),
            AppTextField(
              hint: 'Телефон',
              controller: phoneController,
              focusNode: focusNodes[CourierRequestField.phone],
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\+\s\-]')),
                LengthLimitingTextInputFormatter(16),
              ],
              onChanged:
                  (v) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(CourierRequestField.phone, v),
                  ),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Обязательное поле'
                          : null,
              errorText: errors[CourierRequestField.phone],
            ),
            const Gap(16),
            AppTextField(
              hint: 'Email',
              controller: emailController,
              focusNode: focusNodes[CourierRequestField.email],
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\-]')),
              ],
              onChanged:
                  (v) => context.read<CourierRequestBloc>().add(
                    CourierRequestFieldChanged(CourierRequestField.email, v),
                  ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final reg = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}');
                if (!reg.hasMatch(v)) {
                  return 'Введите корректный email';
                }
                return null;
              },
              errorText: errors[CourierRequestField.email],
            ),
            const Gap(4),
            const Text(
              'На указанный адрес будут приходить оповещения по заявке',
              style: TextStyle(fontSize: 13, color: AppColors.gray700),
            ),
          ],
        );
      },
    );
  }
}
