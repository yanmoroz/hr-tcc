import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../widgets/common/app_show_modular_sheet/components/app_sheet_content_metadata_provider.dart';
import 'app_custom_radio.dart';

class SelectionRadioListContent<T> extends StatefulWidget
    implements AppSheetContentMetadataProvider {
  const SelectionRadioListContent({
    super.key,
    required this.items,
    required this.textStyle,
    required this.selectedValue,
    required this.onSelected,
    required this.itemPaddingVertical,
    required this.modalBackgroundColor,
    this.itemLabelBuilder,
  });

  final List<T> items;
  final TextStyle? textStyle;
  final T selectedValue;
  final ValueChanged<T> onSelected;
  final double itemPaddingVertical;
  final Color modalBackgroundColor;
  final String Function(T value)? itemLabelBuilder;

  @override
  State<SelectionRadioListContent<T>> createState() =>
      _SelectionRadioListContentState<T>();

  @override
  int get estimatedRowCount => items.length;

  @override
  double get estimatedRowHeight =>
      itemPaddingVertical * 2 +
      (textStyle?.fontSize ?? 0) * (textStyle?.height ?? 0); //высота строки
}

class _SelectionRadioListContentState<T>
    extends State<SelectionRadioListContent<T>> {
  late T _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    final labelOf = widget.itemLabelBuilder ?? (T v) => v.toString();

    return Material(
      color: widget.modalBackgroundColor,
      child:
      // List
      Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: widget.items.length,
          separatorBuilder:
              (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final label = labelOf(item);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() => _current = item);
                widget.onSelected(item);
                context.pop();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: widget.itemPaddingVertical,
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(label, style: widget.textStyle)),
                    CustomRadio<T>(
                      value: item,
                      groupValue: _current,
                      activeColor: AppColors.blue700,
                      inactiveColor: AppColors.gray500,
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _current = v);
                        widget.onSelected(v);
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
