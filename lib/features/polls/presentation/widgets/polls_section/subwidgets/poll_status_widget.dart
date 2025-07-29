import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class PollStatusWidget extends StatelessWidget {
  final bool isCompleted;
  final Color textColorDone;
  final Color textColorUnDone;
  final Color bgColorDone;
  final Color bgColorUnDone;

  const PollStatusWidget({
    super.key,
    required this.isCompleted,
    this.textColorDone = AppColors.white,
    this.textColorUnDone = AppColors.black,
    this.bgColorDone = AppColors.gray500,
    this.bgColorUnDone = AppColors.orange100,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isCompleted ? bgColorDone : bgColorUnDone;
    final textColor = isCompleted ? textColorDone : textColorUnDone;
    final label = isCompleted ? 'Пройден' : 'Не пройден';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTypography.caption2Medium.copyWith(color: textColor),
      ),
    );
  }
}
