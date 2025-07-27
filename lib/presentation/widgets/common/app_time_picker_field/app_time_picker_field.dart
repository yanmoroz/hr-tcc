import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/app_colors.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/widgets/common/app_text_field/app_text_field.dart';

class AppTimePickerField extends StatefulWidget {
  final String? hint;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?>? onChanged;
  final String? errorText;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const AppTimePickerField({
    super.key,
    this.hint,
    this.value,
    this.onChanged,
    this.errorText,
    this.enabled = true,
    this.controller,
    this.focusNode,
  });

  @override
  State<AppTimePickerField> createState() => _AppTimePickerFieldState();
}

class _AppTimePickerFieldState extends State<AppTimePickerField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateController();
  }

  @override
  void didUpdateWidget(covariant AppTimePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateController();
    });
  }

  void _updateController() {
    final text = widget.value != null ? widget.value!.format(context) : '';
    if (_controller.text != text) {
      _controller.text = text;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  Future<void> _pickTime() async {
    final platform = Theme.of(context).platform;
    TimeOfDay? picked = widget.value ?? const TimeOfDay(hour: 9, minute: 0);
    if (platform == TargetPlatform.iOS) {
      DateTime tempDateTime = DateTime(0, 0, 0, picked.hour, picked.minute);
      final result = await showCupertinoModalPopup<TimeOfDay>(
        context: context,
        builder:
            (_) => Container(
              height: 320,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text('Отменить'),
                          onPressed: () => context.pop(),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text('Готово'),
                          onPressed: () => context.pop(picked),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: tempDateTime,
                      use24hFormat: true,
                      onDateTimeChanged: (dateTime) {
                        picked = TimeOfDay(
                          hour: dateTime.hour,
                          minute: dateTime.minute,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      );
      if (result != null) {
        widget.onChanged?.call(result);
      }
    } else {
      final result = await showTimePicker(
        context: context,
        initialTime: picked,
        builder: (context, child) => child!,
      );
      if (result != null) {
        widget.onChanged?.call(result);
      }
    }
    // После выбора времени снимаем фокус
    if (_focusNode.hasFocus) _focusNode.unfocus();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      focusNode: _focusNode,
      hint: widget.hint,
      errorText: widget.errorText,
      enabled: widget.enabled,
      readOnly: true,
      onTap: widget.enabled ? _pickTime : null,
      suffix: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Assets.icons.textField.clock.svg(
          height: 24,
          width: 24,
          colorFilter: const ColorFilter.mode(
            AppColors.gray700,
            BlendMode.srcIn,
          ),
        ),
      ),
      showFloatingLabel: true,
    );
  }
}
