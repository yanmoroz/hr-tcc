import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';

class StatusChip extends StatelessWidget {
  final RequestStatus status;
  const StatusChip({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String text = status.name;
    switch (status) {
      case RequestStatus.active:
        bgColor = AppColors.blue300;
        textColor = AppColors.white;
        break;
      case RequestStatus.approved:
        bgColor = AppColors.green500;
        textColor = AppColors.white;
        break;
      case RequestStatus.rejected:
        bgColor = AppColors.red500;
        textColor = AppColors.white;
        break;
      case RequestStatus.completed:
        bgColor = AppColors.gray100;
        textColor = AppColors.gray700;
        break;
      default:
        bgColor = AppColors.black;
        textColor = AppColors.white;
    }
    return Chip(
      label: Text(
        text,
        style: AppTypography.caption2Medium.copyWith(color: textColor),
      ),
      backgroundColor: bgColor,
      side: BorderSide.none,
    );
  }
}
