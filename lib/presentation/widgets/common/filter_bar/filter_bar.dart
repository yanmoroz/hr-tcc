import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';

part 'components/filter_selector_tab.dart';

class FilterBar extends StatelessWidget {
  final Widget Function(FilterTabModel tab, {required bool isSelected})
  filterSelectorTabBuilder;
  final Function(int index) onTabChanged;

  const FilterBar({
    super.key,
    required this.filterSelectorTabBuilder,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        return Container(
          color: AppColors.white,
          width: double.infinity,
          height: 56,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(state.tabs.length, (index) {
                  final tab = state.tabs[index];
                  final bool isSelected = index == state.selectedIndex;
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 16.0 : 0.0,
                      right: 4.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.read<FilterBloc>().add(
                          FilterTabSelected(index),
                        );
                        onTabChanged(index);
                      },
                      child: filterSelectorTabBuilder(
                        tab,
                        isSelected: isSelected,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
