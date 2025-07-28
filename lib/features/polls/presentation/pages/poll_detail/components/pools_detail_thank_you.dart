import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';

import '../../../../../../presentation/widgets/common/app_show_modular_sheet/components/app_sheet_content_metadata_provider.dart';
import 'polls_detail_finish_button.dart';

class PoolsDetailThankYou extends StatelessWidget
    implements AppSheetContentMetadataProvider {
  final VoidCallback onFinishPressed;

  const PoolsDetailThankYou({super.key, required this.onFinishPressed});

  @override
  int get estimatedRowCount => 1;

  @override
  double get estimatedRowHeight => 318;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 22, left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Иконка
                SvgPicture.asset(
                  Assets.icons.pollDetailPage.pollPassed.path,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 16),
                // Заголовок
                Text(
                  'Спасибо за участие!',
                  style: AppTypography.title3Bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Подзаголовок
                Text(
                  'Ваши ответы помогают улучшить наш сервис',
                  style: AppTypography.text2Regular.copyWith(
                    color: AppColors.gray700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Кнопка
                Row(
                  children: [
                    Expanded(
                      child: PollsDetailFinishButton(
                        text: 'Пожалуйста',
                        onPressed: onFinishPressed,
                        enabled: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
