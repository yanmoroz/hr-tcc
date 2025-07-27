import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/blocs.dart';
import '../../navigation/navigation.dart';
import '../../widgets/common/common.dart';
import 'components/components.dart';

class BenefitsWidget extends StatelessWidget {
  const BenefitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              BlocFactory.createBenefitsWidgetBloc()
                ..add(LoadBenefitsWidgetItems()),
      child: BlocBuilder<BenefitsWidgetBloc, BenefitsWidgetState>(
        builder: (context, state) {
          if (state is BenefitsWidgetInitial || state is ResaleWidgetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BenefitsWidgetLoaded) {
            return AppHorizontalSection(
              title: 'Льготы и возможности',
              moreButtonText: 'Перейти в раздел',
              onSeeAll: () {
                context.push(AppRoute.benefits.path);
              },
              cards:
                  state.items.map((model) {
                    return GestureDetector(
                      onTap: () {
                        context.push(AppRoute.benefitContent.path);
                      },
                      child: BenefitsCardWidget(model: model),
                    );
                  }).toList(),
            );
          } else if (state is BenefitsWidgetError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
    // );
  }
}
