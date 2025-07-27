import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

class LockIconButton extends StatelessWidget {
  final bool isLocked;
  final VoidCallback onTapLock;

  const LockIconButton({
    super.key,
    required this.isLocked,
    required this.onTapLock,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTapLock,
      child: SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(
          isLocked
              ? Assets.icons.resale.closedLock.path
              : Assets.icons.resale.openLock.path,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
