import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';

class PollStatusWidget extends StatelessWidget {
  final Color textColorDone;
  final Color textColorUnDone;
  final Color bgColorDone;
  final Color bgColorUnDone;

  const PollStatusWidget({
    super.key,
    required this.status,
    this.textColorDone = AppColors.white,
    this.textColorUnDone = AppColors.black,
    this.bgColorDone = AppColors.gray500,
    this.bgColorUnDone = AppColors.orange100,
  });

  final PollStatus status;

  @override
  Widget build(BuildContext context) {
    final isDone = status == PollStatus.passed;
    final bgColor = isDone ? bgColorDone : bgColorUnDone;
    final textColor = isDone ? textColorDone : textColorUnDone;
    final label = isDone ? 'Пройден' : 'Не пройден';

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
