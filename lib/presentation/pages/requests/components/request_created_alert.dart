import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

class RequestCreatedAlert extends StatefulWidget {
  const RequestCreatedAlert({super.key});

  @override
  State<RequestCreatedAlert> createState() => _RequestCreatedAlertState();
}

class _RequestCreatedAlertState extends State<RequestCreatedAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  bool _closedByUser = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: 1.0,
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    Future.delayed(const Duration(seconds: 1), _autoClose);
  }

  void _autoClose() {
    if (!_closedByUser && mounted) {
      _controller.reverse().then((_) {
        if (mounted && !_closedByUser) context.pop();
      });
    }
  }

  void _closeByUser() {
    _closedByUser = true;
    _controller.reverse().then((_) {
      if (mounted) context.pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withValues(alpha: 0.18)),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 340,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.common.checkboxOutlineGreen.svg(
                        width: 120,
                        height: 120,
                      ),
                      const Gap(8),
                      Text(
                        'Заявка создана',
                        style: AppTypography.title3Semibold.copyWith(
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _closeByUser,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.close,
                      size: 28,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
