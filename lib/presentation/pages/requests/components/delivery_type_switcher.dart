import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class DeliveryTypeSwitcher extends StatelessWidget {
  const DeliveryTypeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourierRequestBloc, CourierRequestState>(
      builder: (context, state) {
        return AppRadioSwitcher<CourierDeliveryType>(
          items: [
            AppRadioSwitcherItem(
              value: CourierDeliveryType.moscow,
              label: 'Заказ курьера по г. Москве',
            ),
            AppRadioSwitcherItem(
              value: CourierDeliveryType.regions,
              label: 'Экспресс-доставка по регионам',
            ),
          ],
          groupValue: state.deliveryType,
          onChanged: (v) {
            context.read<CourierRequestBloc>().add(
              CourierRequestDeliveryTypeChanged(v),
            );
          },
        );
      },
    );
  }
}
