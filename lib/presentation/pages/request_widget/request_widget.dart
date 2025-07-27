import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/request_widget/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/presentation/navigation/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Widget
class RequestsWidget extends StatelessWidget {
  const RequestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              BlocFactory.createRequestsWidgetBloc()..add(RequestsWidgetLoad()),
      child: BlocBuilder<RequestsWidgetBloc, RequestsWidgetState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return VerticalSection(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            title: 'Заявки',
            cards: [
              AppInfoCard(
                color: AppColors.white,
                shadowColor: AppColors.cardShadowColor,
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 12,
                  right: 12,
                  bottom: 12,
                ),
                children: [
                  ...RequestWidgetRow.buildRowsFactory(
                    state.items,
                    onTapBuilder: (i, item) => () => context.push(item.route),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: 'Создать заявку',
                    variant: AppButtonVariant.secondary,
                    isFullWidth: true,
                    icon: Icons.add,
                    iconColor: AppColors.gray700,
                    size: AppButtonSize.small,
                    onPressed: () => {context.push(AppRoute.newRequest.path)},
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
