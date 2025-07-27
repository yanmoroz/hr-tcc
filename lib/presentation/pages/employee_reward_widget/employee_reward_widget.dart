import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/blocs.dart';
import '../../navigation/navigation.dart';
import 'components/components.dart';

class EmployeeRewardWidget extends StatelessWidget {
  final Color backgroundColor;
  final double cornerRadiusBar;

  const EmployeeRewardWidget({
    super.key,
    required this.backgroundColor,
    required this.cornerRadiusBar,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              BlocFactory.createEmployeeRewardBloc()
                ..add(EmployeeRewardLoaded()),
      child: BlocBuilder<EmployeeRewardBloc, EmployeeRewardState>(
        builder: (context, state) {
          if (state is EmployeeRewardInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeRewardLoadedState) {
            final model = state.salaryBonusKpiModel;
            return Container(
              height: 72,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(cornerRadiusBar),
                  bottomRight: Radius.circular(cornerRadiusBar),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      context.push(AppRoute.userProfile.path);
                    },
                    child: SalaryBonusCardWidget(
                      title: 'Зарплата',
                      value: model.salary,
                    ),
                  ),
                  // const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      context.push(AppRoute.userKpi.path);
                    },
                    child: SalaryBonusCardWidget(
                      title: 'Премия',
                      value: model.bonus,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(AppRoute.userKpi.path);
                    },
                    child: KpiCardWidget(
                      title: 'КПЭ',
                      progressPersent: model.kpiProgress,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
