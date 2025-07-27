import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_typography.dart';
import '../../../../generated/assets.gen.dart';
import 'components/outlined_input_border.dart';

class AppTextField extends StatefulWidget {
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool showFloatingLabel;
  final Color? fillColor;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const AppTextField({
    super.key,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
    this.showFloatingLabel = true,
    this.fillColor,
    this.floatingLabelBehavior,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  bool _obscureText = false;
  bool _hasError = false;
  late AnimationController _animationController;
  late Animation<double> _errorAnimation;
  late FocusNode _focusNode;
  // bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _errorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted) return;
    setState(() {
      // _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!mounted) return;

    final hasError = widget.errorText != null;
    if (hasError != _hasError) {
      _hasError = hasError;
      if (hasError) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _errorAnimation,
      builder: (context, child) {
        return TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (_hasError && widget.validator?.call(value) == null) {
              if (!mounted) return;
              setState(() {
                _hasError = false;
                _animationController.reverse();
              });
            }
          },
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          enabled: widget.enabled,
          focusNode: _focusNode,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: AppTypography.text1Regular.copyWith(color: AppColors.black),
          decoration: InputDecoration(
            hintText: widget.showFloatingLabel ? null : widget.hint,
            labelText: widget.showFloatingLabel ? widget.hint : null,
            floatingLabelBehavior:
                widget.floatingLabelBehavior ??
                (widget.showFloatingLabel
                    ? FloatingLabelBehavior.auto
                    : FloatingLabelBehavior.never),
            floatingLabelAlignment: FloatingLabelAlignment.start,

            floatingLabelStyle: AppTypography.text1Regular.copyWith(
              color: AppColors.gray700,
            ),
            hintStyle: AppTypography.text1Regular.copyWith(
              color:
                  widget.errorText != null
                      ? AppColors.red500
                      : AppColors.gray700,
            ),
            errorText: widget.errorText,
            errorMaxLines: 2,
            helperStyle: const TextStyle(height: 0),
            errorStyle: AppTypography.text2Regular.copyWith(
              color: AppColors.red500,
              height: 1.2,
            ),
            prefixIcon: widget.prefix,
            suffixIcon:
                widget.obscureText
                    ? IconButton(
                      icon:
                          _obscureText
                              ? Assets.icons.textField.eyeOff.svg(
                                colorFilter: const ColorFilter.mode(
                                  AppColors.gray700,
                                  BlendMode.srcIn,
                                ),
                              )
                              : Assets.icons.textField.eyeOn.svg(
                                colorFilter: const ColorFilter.mode(
                                  AppColors.gray700,
                                  BlendMode.srcIn,
                                ),
                              ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : widget.suffix,

            filled: true,
            fillColor:
                widget.enabled
                    ? (widget.fillColor ?? AppColors.white)
                    : AppColors.gray50,
            border: OutlinedInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray500, width: 1),
            ),
            enabledBorder: OutlinedInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray500, width: 1),
            ),
            focusedBorder: OutlinedInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.blue300,
                width: 1.0,
              ),
            ),
            errorBorder: OutlinedInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red500, width: 1.5),
            ),
            focusedErrorBorder: OutlinedInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red500, width: 1.5),
            ),
            contentPadding:
                widget.showFloatingLabel
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        );
      },
    );
  }
}
