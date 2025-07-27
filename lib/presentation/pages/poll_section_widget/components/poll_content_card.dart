import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/pages/poll_section_widget/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class PollContentCard extends StatelessWidget {
  final PollCardModel poll;
  final VoidCallback onTap;
  final Color imageBorderColor;
  final Color timestampColor;
  final Color subtitleColor;
  final Color buttonColor;
  final Color buttonTextColor;

  const PollContentCard({
    super.key,
    required this.poll,
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
            if (poll.imageUrl != null) ...[
              AppImageWithBorder(
                imageUrl: poll.imageUrl ?? '',
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
                    poll.timestamp,
                    style: AppTypography.caption2Medium.copyWith(
                      color: timestampColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(poll.title, style: AppTypography.text1Medium),
                  const SizedBox(height: 4),
                  Text(
                    poll.subtitle,
                    style: AppTypography.text2Regular.copyWith(
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      StatusPoll(status: poll.status),
                      const Spacer(),
                      Text(
                        'Прошли: ${poll.passedCount}',
                        style: AppTypography.text2Regular,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (poll.status == PollStatus.notPassed) ...[
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
