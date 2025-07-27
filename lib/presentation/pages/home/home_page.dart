import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/pages/pages.dart';
import 'package:hr_tcc/presentation/pages/resale_widget/resale_widget.dart';

class HomePage extends StatelessWidget {
  final Color backgroundColorBar;
  final double cornerRadiusBar;

  const HomePage({
    super.key,
    this.backgroundColorBar = AppColors.white,
    this.cornerRadiusBar = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainPageWrapperWithScroll(
        backgroundColorBar: backgroundColorBar,
        cornerRadius: cornerRadiusBar,
        children: [
          EmployeeRewardWidget(
            backgroundColor: backgroundColorBar,
            cornerRadiusBar: cornerRadiusBar,
          ),
          const RequestsWidget(),
          const QuickLinksWidget(),
          const ResaleWidget(),
          const PollSectionWidget(),
          const NewsSectionWidget(),
          const BenefitsWidget(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
