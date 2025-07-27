import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/employee_list_selector/employee_card.dart';

class EmployeeListSelector<T> extends StatelessWidget {
  final String title;
  final String addButtonText;
  final List<T> allEmployees;
  final List<T> selectedEmployees;
  final String Function(T) itemLabel;
  final String? Function(T)? subtitleLabel;
  final void Function(T) onAdd;
  final void Function(T) onRemove;
  final String? errorText;
  final bool multiple;
  final void Function(List<T>)? onChanged;
  final int? maxCount;

  const EmployeeListSelector({
    super.key,
    required this.title,
    required this.addButtonText,
    required this.allEmployees,
    required this.selectedEmployees,
    required this.itemLabel,
    required this.onAdd,
    required this.onRemove,
    this.subtitleLabel,
    this.errorText,
    this.multiple = false,
    this.onChanged,
    this.maxCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.title3Bold),
        const SizedBox(height: 16),
        ..._buildEmployeeFields(context),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: addButtonText,
            icon: Icons.add,
            variant: AppButtonVariant.secondary,
            isFullWidth: true,
            onPressed: () async {
              final available =
                  allEmployees
                      .where((e) => !selectedEmployees.contains(e))
                      .toList();
              if (available.isEmpty) return;
              if (multiple) {
                List<T>? result = await showModalBottomSheet<List<T>>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder:
                      (context) => CommonModalSelectorSheet<T>(
                        title: addButtonText,
                        items: available,
                        selectedList: selectedEmployees,
                        multiple: true,
                        maxCount: maxCount,
                        itemLabel: itemLabel,
                        subtitleLabel: subtitleLabel,
                        onSelected: (values) => context.pop(values),
                        searchHint: 'ФИО',
                      ),
                );
                if (result != null) {
                  if (onChanged != null) {
                    onChanged!(result);
                  } else {
                    for (final e in result) {
                      if (!selectedEmployees.contains(e)) {
                        onAdd(e);
                      }
                    }
                  }
                }
              } else {
                T? result = await showModalBottomSheet<T>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder:
                      (context) => CommonModalSelectorSheet<T>(
                        title: addButtonText,
                        items: available,
                        selected: null,
                        itemLabel: itemLabel,
                        subtitleLabel: subtitleLabel,
                        onSelected: (value) {
                          context.pop(value);
                        },
                        searchHint: 'ФИО',
                      ),
                );
                if (result != null) {
                  onAdd(result);
                }
              }
            },
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: AppTypography.text2Regular.copyWith(color: AppColors.red500),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildEmployeeFields(BuildContext context) {
    if (selectedEmployees.isEmpty) return [];
    return selectedEmployees.map((e) {
      return EmployeeCard(
        title: itemLabel(e),
        subtitle: subtitleLabel?.call(e),
        onRemove: () {
          onRemove(e);
        },
      );
    }).toList();
  }
}
