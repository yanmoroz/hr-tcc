import 'package:flutter/material.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../generated/assets.gen.dart';
import '../app_text_field/app_text_field.dart';
import 'components/custom_date_picker_dialog.dart';

enum AppDatePickerMode { single, range }

class AppDatePickerField extends StatefulWidget {
  final String? hint;
  final DateTime? value;
  final DateTimeRange? rangeValue;
  final ValueChanged<DateTime?>? onChanged;
  final ValueChanged<DateTimeRange?>? onRangeChanged;
  final String? errorText;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final AppDatePickerMode mode;
  final bool showPastDates;

  const AppDatePickerField({
    super.key,
    this.hint,
    this.value,
    this.rangeValue,
    this.onChanged,
    this.onRangeChanged,
    this.errorText,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.mode = AppDatePickerMode.single,
    this.showPastDates = false,
  });

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  late final FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(text: _displayText ?? '');
  }

  @override
  void didUpdateWidget(covariant AppDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = _displayText ?? '';
    if (_controller.text != newText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.text = newText;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  String? get _displayText {
    if (widget.mode == AppDatePickerMode.single) {
      return widget.value != null
          ? AppDateUtils.formatDate(widget.value!)
          : null;
    } else {
      if (widget.rangeValue != null) {
        return '${AppDateUtils.formatDate(widget.rangeValue!.start)} - ${AppDateUtils.formatDate(widget.rangeValue!.end)}';
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue =
        (widget.mode == AppDatePickerMode.single)
            ? widget.value != null
            : widget.rangeValue != null;
    final showLabel = _focusNode.hasFocus || hasValue;
    final DateTime? initial =
        widget.mode == AppDatePickerMode.single
            ? widget.value
            : widget.rangeValue?.start;

    // Гарантируем, что initialDate, firstDate, lastDate всегда без времени (только дата)
    DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
    final DateTime? firstDateOnly =
        widget.firstDate != null ? dateOnly(widget.firstDate!) : null;
    final DateTime? lastDateOnly =
        widget.lastDate != null ? dateOnly(widget.lastDate!) : null;
    final DateTime? valueOnly = initial != null ? dateOnly(initial) : null;

    DateTime getInitialDate() {
      final today = dateOnly(DateTime.now());
      final first = firstDateOnly;
      final last = lastDateOnly;
      final value = valueOnly;

      if (first != null && value != null) {
        if (value.isBefore(first)) return first;
        if (last != null && value.isAfter(last)) return last;
        return value;
      }
      if (first != null) return first;
      if (value != null) return value;
      return today;
    }

    return AppTextField(
      controller: _controller,
      readOnly: true,
      enabled: widget.enabled,
      hint: widget.hint,
      errorText: widget.errorText,
      showFloatingLabel: showLabel,
      focusNode: _focusNode,
      suffix: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Assets.icons.textField.calendar.svg(
          height: 24,
          width: 24,
          colorFilter: const ColorFilter.mode(
            AppColors.gray700,
            BlendMode.srcIn,
          ),
        ),
      ),
      onTap:
          widget.enabled
              ? () {
                bool dateSelected = false;
                showCustomDatePickerBottomSheet(
                  context: context,
                  initialDate: getInitialDate(),
                  firstDate: firstDateOnly ?? DateTime(2000),
                  lastDate: lastDateOnly ?? DateTime(2100),
                  mode: widget.mode,
                  onDateSelected: (date) {
                    dateSelected = true;
                    widget.onChanged?.call(date);
                    if (_focusNode.hasFocus) _focusNode.unfocus();
                  },
                  onRangeSelected: (range) {
                    dateSelected = true;
                    widget.onRangeChanged?.call(range);
                    if (_focusNode.hasFocus) _focusNode.unfocus();
                  },
                  initialRange: widget.rangeValue,
                  showPastDates: widget.showPastDates,
                );
                // После закрытия диалога, если дата не выбрана, снять фокус
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (!dateSelected && _focusNode.hasFocus) {
                    _focusNode.unfocus();
                    setState(() {});
                  }
                });
              }
              : null,
    );
  }
}
