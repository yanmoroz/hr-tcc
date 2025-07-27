import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

enum AppHintCardType { info, success, warning, error }

enum AppHintCardArrowPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  top,
  bottom,
  left,
  right,
}

enum AppHintCardContentType { text, richText, widget }

class AppHintCard extends StatelessWidget {
  final dynamic content;
  final AppHintCardContentType contentType;
  final AppHintCardType type;
  final AppHintCardArrowPosition arrowPosition;
  final double arrowWidth;
  final double arrowHeight;
  final double arrowOffset;
  final BorderRadius borderRadius;

  const AppHintCard({
    super.key,
    required this.content,
    this.contentType = AppHintCardContentType.text,
    this.type = AppHintCardType.info,
    this.arrowPosition = AppHintCardArrowPosition.topRight,
    this.arrowWidth = 26,
    this.arrowHeight = 12,
    this.arrowOffset = 24,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  Color get _color {
    switch (type) {
      case AppHintCardType.success:
        return AppColors.green100;
      case AppHintCardType.warning:
        return AppColors.yellow100;
      case AppHintCardType.error:
        return AppColors.red100;
      case AppHintCardType.info:
        return AppColors.blue100.withAlpha(100);
    }
  }

  Widget _buildContent() {
    switch (contentType) {
      case AppHintCardContentType.text:
        if (content is String) {
          return Text(
            content,
            style: AppTypography.text2Regular.copyWith(color: AppColors.black),
          );
        } else if (content is Widget) {
          return content;
        } else {
          return const SizedBox();
        }
      case AppHintCardContentType.richText:
      case AppHintCardContentType.widget:
        if (content is Widget) {
          return content;
        } else {
          return const SizedBox();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(color: _color, borderRadius: borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _buildContent(),
          ),
        ),
        Positioned(
          top:
              (arrowPosition == AppHintCardArrowPosition.topLeft ||
                      arrowPosition == AppHintCardArrowPosition.topRight ||
                      arrowPosition == AppHintCardArrowPosition.top)
                  ? -arrowHeight
                  : null,
          bottom:
              (arrowPosition == AppHintCardArrowPosition.bottomLeft ||
                      arrowPosition == AppHintCardArrowPosition.bottomRight ||
                      arrowPosition == AppHintCardArrowPosition.bottom)
                  ? -arrowHeight
                  : null,
          left:
              (arrowPosition == AppHintCardArrowPosition.topLeft ||
                      arrowPosition == AppHintCardArrowPosition.bottomLeft ||
                      arrowPosition == AppHintCardArrowPosition.left)
                  ? arrowOffset
                  : (arrowPosition == AppHintCardArrowPosition.top ||
                      arrowPosition == AppHintCardArrowPosition.bottom)
                  ? 0
                  : null,
          right:
              (arrowPosition == AppHintCardArrowPosition.topRight ||
                      arrowPosition == AppHintCardArrowPosition.bottomRight ||
                      arrowPosition == AppHintCardArrowPosition.right)
                  ? arrowOffset
                  : (arrowPosition == AppHintCardArrowPosition.top ||
                      arrowPosition == AppHintCardArrowPosition.bottom)
                  ? 0
                  : null,
          child:
              (arrowPosition == AppHintCardArrowPosition.top ||
                      arrowPosition == AppHintCardArrowPosition.bottom)
                  ? Align(
                    alignment:
                        arrowPosition == AppHintCardArrowPosition.top
                            ? Alignment.topCenter
                            : Alignment.bottomCenter,
                    child: CustomPaint(
                      size: Size(arrowWidth, arrowHeight),
                      painter: _AppHintCardArrowPainter(
                        color: _color,
                        position: arrowPosition,
                      ),
                    ),
                  )
                  : CustomPaint(
                    size: Size(arrowWidth, arrowHeight),
                    painter: _AppHintCardArrowPainter(
                      color: _color,
                      position: arrowPosition,
                    ),
                  ),
        ),
      ],
    );
  }
}

class _AppHintCardArrowPainter extends CustomPainter {
  final Color color;
  final AppHintCardArrowPosition position;

  _AppHintCardArrowPainter({required this.color, required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final path = Path();
    switch (position) {
      case AppHintCardArrowPosition.topLeft:
        path.moveTo(0, size.height);
        path.lineTo(0, 0);
        path.lineTo(size.width, size.height);
        break;
      case AppHintCardArrowPosition.top:
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        break;
      case AppHintCardArrowPosition.topRight:
        path.moveTo(0, size.height);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        break;
      case AppHintCardArrowPosition.bottomLeft:
        path.moveTo(0, 0);
        path.lineTo(0, size.height);
        path.lineTo(size.width, 0);
        break;
      case AppHintCardArrowPosition.bottom:
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        break;
      case AppHintCardArrowPosition.bottomRight:
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, 0);
        break;
      case AppHintCardArrowPosition.left:
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(0, size.height);
        break;
      case AppHintCardArrowPosition.right:
        path.moveTo(size.width, 0);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
