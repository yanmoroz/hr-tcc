import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/user_kpi/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class UserKpiPage extends StatelessWidget {
  const UserKpiPage({super.key});

  final backgroundColor = AppColors.gray100;
  final cardColor = AppColors.white;
  final cardShadowColor = AppColors.cardShadowColor;
  final subTitleColor = AppColors.gray700;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BlocFactory.createUserKpiBloc()..add(LoadKpiGroups()),
        ),
        BlocProvider(
          create:
              (_) => BlocFactory.createFilterBloc(UserKpiBloc.kpiPeriodTabs),
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppNavigationBar(
          title: 'Итоговый расчёт КПЭ',
          leftIconAsset: Assets.icons.navigationBar.back.path,
        ),
        body: BlocBuilder<UserKpiBloc, KpiState>(
          builder: (context, state) {
            if (state is! KpiLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final group = state.groups[state.currentIndex];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocListener<FilterBloc, FilterState>(
                    listenWhen:
                        (prev, curr) =>
                            prev.selectedIndex != curr.selectedIndex,
                    listener: (context, state) {
                      final selectedLabel =
                          state.tabs[state.selectedIndex].label;
                      context.read<UserKpiBloc>().add(
                        ChangeKpiPeriod(selectedLabel),
                      );
                    },
                    child: FilterBar(
                      filterSelectorTabBuilder: (
                        tab, {
                        required bool isSelected,
                      }) {
                        return FilterBarTab(isSelected: isSelected, tab: tab);
                      },
                      onTabChanged: (index) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        KpiGroupSwitcher(state: state),
                        const SizedBox(height: 16),
                        Text(group.title, style: AppTypography.title2Bold),
                        const SizedBox(height: 8),
                        Text(
                          group.subtitle,
                          style: AppTypography.text2Regular.copyWith(
                            color: subTitleColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        PlanValuesSection(
                          group: group,
                          cardColor: cardColor,
                          shadowColor: cardShadowColor,
                          labelColor: subTitleColor,
                        ),
                        const SizedBox(height: 24),
                        TargetKpiSection(
                          group: group,
                          cardColor: cardColor,
                          shadowColor: cardShadowColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
