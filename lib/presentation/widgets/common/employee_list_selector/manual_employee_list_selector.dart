import 'package:flutter/material.dart';

import '../../../../config/themes/themes.dart';
import '../../../../generated/assets.gen.dart';
import '../../../widgets/common/common.dart';

class ManualEmployeeListSelector extends StatelessWidget {
  final String title;
  final String addButtonText;
  final List<String> values;
  final void Function(List<String>) onChanged;
  final String? errorText;
  final int maxCount;
  final String? footerHint;

  const ManualEmployeeListSelector({
    super.key,
    required this.title,
    required this.addButtonText,
    required this.values,
    required this.onChanged,
    this.errorText,
    this.maxCount = 5,
    this.footerHint,
  });

  @override
  Widget build(BuildContext context) {
    final isMax = values.length >= maxCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.title3Bold),
        const SizedBox(height: 16),
        ...List.generate(
          values.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ManualEmployeeTextField(
              value: values[i],
              onChanged: (v) {
                final updated = List<String>.from(values);
                updated[i] = v;
                onChanged(updated);
              },
              onRemove: () {
                final updated = List<String>.from(values)..removeAt(i);
                onChanged(updated);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: addButtonText,
            icon: Icons.add,
            variant: AppButtonVariant.secondary,
            isFullWidth: true,
            isDisabled: isMax,
            onPressed:
                isMax
                    ? null
                    : () {
                      final updated = List<String>.from(values)..add('');
                      onChanged(updated);
                    },
          ),
        ),
        if (isMax)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Максимум $maxCount человек',
              style: AppTypography.text2Regular.copyWith(
                color: AppColors.gray500,
              ),
            ),
          ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: AppTypography.text2Regular.copyWith(color: AppColors.red500),
          ),
        ],
        if (footerHint != null) ...[
          const SizedBox(height: 16),
          Text(
            footerHint!,
            style: AppTypography.text2Regular.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ],
    );
  }
}

class _ManualEmployeeTextField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  const _ManualEmployeeTextField({
    required this.value,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<_ManualEmployeeTextField> createState() =>
      _ManualEmployeeTextFieldState();
}

class _ManualEmployeeTextFieldState extends State<_ManualEmployeeTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _ManualEmployeeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      final selection = _controller.selection;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.text = widget.value;
        if (selection.start <= widget.value.length) {
          _controller.selection = selection;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      hint: 'ФИО',
      onChanged: widget.onChanged,
      suffix: GestureDetector(
        onTap: widget.onRemove,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Assets.icons.textField.trash.svg(width: 24, height: 24),
        ),
      ),
    );
  }
}
