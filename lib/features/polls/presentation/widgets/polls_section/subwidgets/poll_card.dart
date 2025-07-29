import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import '../../../../domain/entities/poll_status.dart';
import '../../../viewmodels/poll_card_view_model.dart';
import 'poll_status_widget.dart';

class PollCard extends StatelessWidget {
  final PollCardViewModel viewModel;
  final VoidCallback onTap;
  final Color imageBorderColor;
  final Color timestampColor;
  final Color subtitleColor;
  final Color buttonColor;
  final Color buttonTextColor;

  const PollCard({
    super.key,
    required this.viewModel,
    required this.onTap,
    this.imageBorderColor = AppColors.gray100,
    this.timestampColor = AppColors.gray700,
    this.subtitleColor = AppColors.gray700,
    this.buttonColor = AppColors.blue700,
    this.buttonTextColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.imageUrl != null) ...[
              AppImageWithBorder(
                imageUrl: viewModel.imageUrl ?? '',
                width: 60,
                height: 60,
                borderRadius: 8,
                borderColor: imageBorderColor,
                borderWidth: 1.0,
                borderPadding: 0,
                imageRadius: 8,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.createdAt,
                    style: AppTypography.caption2Medium.copyWith(
                      color: timestampColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(viewModel.title, style: AppTypography.text1Medium),
                  const SizedBox(height: 4),
                  Text(
                    viewModel.subtitle,
                    style: AppTypography.text2Regular.copyWith(
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      PollStatusWidget(
                        isCompleted: viewModel.status == PollStatus.completed,
                      ),
                      const Spacer(),
                      Text(
                        'Прошли: ${viewModel.passedCount}',
                        style: AppTypography.text2Regular,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (viewModel.status == PollStatus.notCompleted) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onTap,
              child: Text(
                'Пройти опрос',
                style: AppTypography.text2Medium.copyWith(
                  color: buttonTextColor,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
