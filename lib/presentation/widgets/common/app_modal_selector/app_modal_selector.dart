import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class AppModalSelector<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T? selected;
  final String Function(T) itemLabel;
  final String? Function(T)? subtitleLabel;
  final void Function(T) onSelected;
  final String? searchHint;
  final bool showFloatingLabel;
  final String? errorText;

  const AppModalSelector({
    super.key,
    required this.title,
    required this.items,
    required this.selected,
    required this.itemLabel,
    required this.onSelected,
    this.searchHint,
    this.showFloatingLabel = true,
    this.errorText,
    this.subtitleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet<T>(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder:
              (context) => CommonModalSelectorSheet<T>(
                title: title,
                items: items,
                selected: selected,
                itemLabel: itemLabel,
                onSelected: (value) {
                  context.pop(value);
                },
                searchHint: searchHint,
                subtitleLabel: subtitleLabel,
              ),
        );
        if (result != null) {
          onSelected(result);
        }
      },
      child: AbsorbPointer(
        child: AppTextField(
          controller: TextEditingController(
            text: selected != null ? itemLabel(selected as T) : '',
          ),
          hint: title,
          showFloatingLabel: showFloatingLabel,
          suffix: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Assets.icons.textField.chevronDown.svg(
              width: 24,
              height: 24,
            ),
          ),
          readOnly: true,
          errorText: errorText,
        ),
      ),
    );
  }
}
