import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/themes/themes.dart';
import '../../../../generated/assets.gen.dart';
import '../../../widgets/common/common.dart';

class CommonModalSelectorSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? selected;
  final List<T>? selectedList;
  final String Function(T) itemLabel;
  final String? Function(T)? subtitleLabel;
  final void Function(dynamic) onSelected; // dynamic: T или List<T>
  final String? searchHint;
  final bool multiple;
  final int? maxCount;

  const CommonModalSelectorSheet({
    super.key,
    required this.title,
    required this.items,
    this.selected,
    this.selectedList,
    required this.itemLabel,
    required this.onSelected,
    this.searchHint,
    this.subtitleLabel,
    this.multiple = false,
    this.maxCount,
  });

  @override
  State<CommonModalSelectorSheet<T>> createState() =>
      _CommonModalSelectorSheetState<T>();
}

class _CommonModalSelectorSheetState<T>
    extends State<CommonModalSelectorSheet<T>> {
  String _search = '';
  late List<T> _selectedList;

  @override
  void initState() {
    super.initState();
    _selectedList = List<T>.from(widget.selectedList ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        widget.items
            .where(
              (e) => widget
                  .itemLabel(e)
                  .toLowerCase()
                  .contains(_search.toLowerCase()),
            )
            .toList();
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom:
                  widget.multiple
                      ? 72
                      : MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: AppTypography.title3Bold.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Assets.icons.textField.close.svg(),
                        color: AppColors.gray700,
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),
                if (widget.searchHint != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 48,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: widget.searchHint,
                          hintStyle: AppTypography.text1Medium.copyWith(
                            color: AppColors.gray500,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.gray700,
                          ),
                          filled: true,
                          fillColor: AppColors.gray100,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: AppTypography.text1Medium.copyWith(
                          color: AppColors.black,
                        ),
                        onChanged: (v) => setState(() => _search = v),
                      ),
                    ),
                  ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder:
                        (_, __) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(height: 1, color: AppColors.gray100),
                        ),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected =
                          widget.multiple
                              ? _selectedList.contains(item)
                              : item == widget.selected;

                      // Проверяем, отключен ли элемент
                      final isDisabled =
                          widget.multiple &&
                          widget.maxCount != null &&
                          !isSelected &&
                          _selectedList.length >= widget.maxCount!;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        title: Text(
                          widget.itemLabel(item),
                          style: AppTypography.text1Medium.copyWith(
                            color:
                                isDisabled
                                    ? AppColors.gray500
                                    : AppColors.black,
                          ),
                        ),
                        subtitle:
                            widget.subtitleLabel != null &&
                                    widget.subtitleLabel!(item) != null
                                ? Text(
                                  widget.subtitleLabel!(item)!,
                                  style: AppTypography.text2Regular.copyWith(
                                    color:
                                        isDisabled
                                            ? AppColors.gray500
                                            : AppColors.gray700,
                                  ),
                                )
                                : null,
                        trailing:
                            widget.multiple
                                ? AppCheckBox(
                                  value: isSelected,
                                  enabled:
                                      widget.maxCount == null ||
                                      _selectedList.length < widget.maxCount! ||
                                      isSelected,
                                  onChanged: (bool checked) {
                                    // Проверяем, можно ли изменить состояние
                                    if (widget.maxCount != null &&
                                        !isSelected &&
                                        _selectedList.length >=
                                            widget.maxCount! &&
                                        checked == true) {
                                      return; // Не добавляем, если достигнут максимум
                                    }

                                    setState(() {
                                      if (checked == true) {
                                        if (widget.maxCount == null ||
                                            _selectedList.length <
                                                widget.maxCount!) {
                                          _selectedList.add(item);
                                        }
                                      } else {
                                        _selectedList.remove(item);
                                      }
                                    });
                                  },
                                )
                                : (isSelected
                                    ? const Icon(
                                      Icons.radio_button_checked,
                                      color: AppColors.blue700,
                                    )
                                    : const Icon(
                                      Icons.radio_button_unchecked,
                                      color: AppColors.gray500,
                                    )),
                        onTap: () {
                          if (widget.multiple) {
                            // Проверяем, можно ли добавить элемент
                            if (!isSelected &&
                                widget.maxCount != null &&
                                _selectedList.length >= widget.maxCount!) {
                              return; // Не добавляем, если достигнут максимум
                            }

                            setState(() {
                              if (isSelected) {
                                _selectedList.remove(item);
                              } else {
                                if (widget.maxCount == null ||
                                    _selectedList.length < widget.maxCount!) {
                                  _selectedList.add(item);
                                }
                              }
                            });
                          } else {
                            widget.onSelected(item);
                            // context.pop();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (widget.multiple)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: AppColors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Выбрать',
                      onPressed:
                          _selectedList.isEmpty
                              ? null
                              : () {
                                widget.onSelected(_selectedList);
                                // context.pop();
                              },
                      variant: AppButtonVariant.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
