import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/resale_list_page/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import '../../navigation/navigation.dart';

class ResaleListPage extends StatelessWidget {
  const ResaleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: const AppNavigationBar(title: 'Ресейл'),
      body: BlocBuilder<ResaleListPageBloc, ResaleListPageState>(
        builder: (context, state) {
          final bloc = context.read<ResaleListPageBloc>();
          final items = state.groupedItems[state.selectedFilter] ?? [];

          return Column(
            children: [
              BlocListener<ResaleListPageBloc, ResaleListPageState>(
                listenWhen:
                    (prev, curr) => prev.groupedItems != curr.groupedItems,
                listener: (context, state) {
                  context.read<FilterBloc>().add(
                    SetFilterTabs<SaleStatus>(state.filterTabs),
                  );
                },
                child: BlocListener<FilterBloc, FilterState>(
                  listenWhen:
                      (prev, curr) => prev.selectedIndex != curr.selectedIndex,
                  listener: (context, filterState) {
                    final selected = filterState.selectedTab.value;
                    context.read<ResaleListPageBloc>().add(
                      FilterResaleListByStatus(selected),
                    );
                  },
                  child: FilterBar(
                    filterSelectorTabBuilder: (
                      tab, {
                      required bool isSelected,
                    }) {
                      return FilterBarTab(isSelected: isSelected, tab: tab);
                    },
                    onTabChanged: (_) {},
                  ),
                ),
              ),
              Container(
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    height: 40,
                    child: AppSearchField(
                      hint: 'Поиск',
                      onChanged: (query) {
                        context.read<ResaleListPageBloc>().add(
                          SearchFieldChangeResaleListPage(query),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child:
                    items.isEmpty
                        ? const Center(child: Text('Нет объявлений'))
                        : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  context.push(AppRoute.resaleDetail.path);
                                },
                                child: AppInfoCard(
                                  color: AppColors.white,
                                  shadowColor: AppColors.cardShadowColor,
                                  children: [
                                    ResaleListPageCardContent(
                                      item: item,
                                      onTapLock: () {
                                        bloc.add(
                                          TapOnResaleListCardButton(item),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
