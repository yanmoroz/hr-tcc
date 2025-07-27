import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class AppTextArea extends StatefulWidget {
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final int minLines;
  final int maxLines;
  final bool enabled;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool alwaysShowLabel;

  const AppTextArea({
    super.key,
    this.hint,
    this.errorText,
    this.controller,
    this.minLines = 3,
    this.maxLines = 8,
    this.enabled = true,
    this.onChanged,
    this.focusNode,
    this.alwaysShowLabel = false,
  });

  @override
  State<AppTextArea> createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _animController;
  late final Animation<double> _opacityAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<Offset> _offsetAnim;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_handleChanged);
    _focusNode.addListener(_handleFocus);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacityAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _offsetAnim = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.2), // немного влево и вверх
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateAnim());
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  void _handleChanged() {
    if (!mounted) return;
    setState(() {});
    _updateAnim();
  }

  void _handleFocus() {
    if (!mounted) return;
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    _updateAnim();
  }

  void _updateAnim() {
    final shouldHide = _controller.text.isNotEmpty || _isFocused;
    if (shouldHide) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final showCustomHint = widget.hint != null;
    return Stack(
      children: [
        AppTextField(
          hint: (_controller.text.isEmpty && !_isFocused) ? null : widget.hint,
          errorText: widget.errorText,
          controller: _controller,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          onChanged: (v) {
            widget.onChanged?.call(v);
            setState(() {});
          },
          focusNode: _focusNode,
          showFloatingLabel: !(_controller.text.isEmpty && !_isFocused),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        if (showCustomHint)
          Positioned(
            left: 16,
            top: 12,
            right: 16,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnim.value,
                    child: Transform.translate(
                      offset: Offset(
                        _offsetAnim.value.dx *
                            MediaQuery.of(context).size.width,
                        _offsetAnim.value.dy * 24, // 24 — высота label примерно
                      ),
                      child: Transform.scale(
                        scale: _scaleAnim.value,
                        alignment: Alignment.topLeft,
                        child: child,
                      ),
                    ),
                  );
                },
                child:
                    widget.hint == null
                        ? const SizedBox.shrink()
                        : Text(
                          widget.hint!,
                          style: AppTypography.text1Regular.copyWith(
                            color: AppColors.gray700,
                          ),
                        ),
              ),
            ),
          ),
      ],
    );
  }
}
