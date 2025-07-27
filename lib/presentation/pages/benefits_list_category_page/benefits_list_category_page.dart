import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/models/models.dart';

import '../../../config/themes/themes.dart';
import '../../../generated/assets.gen.dart';
import '../../blocs/blocs.dart';
import '../../navigation/navigation.dart';
import '../../widgets/common/common.dart';
import 'components/components.dart';

class BenefitsListCategoryPage extends StatelessWidget {
  const BenefitsListCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Льготы и возможности',
        subTitle:
            context
                .read<BenefitsListCategoryPageBloc>()
                .selectedCategory
                .subTitle,
        leftIconAsset: Assets.icons.navigationBar.back.path,
      ),
      backgroundColor: AppColors.gray100,
      body: SafeArea(
        child: BlocBuilder<
          BenefitsListCategoryPageBloc,
          BenefitsListCategoryPageState
        >(
          builder: (context, state) {
            if (state is BenefitsListCategoryPageLoaded) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  AppSectionWithCard(
                    title: '',
                    cards:
                        state.model
                            .map(
                              (model) => GestureDetector(
                                onTap: () {
                                  context.push(AppRoute.benefitContent.path);
                                },
                                child: AppInfoCard(
                                  gradient: AppColors.gradientCardBenefits,
                                  shadowColor: AppColors.cardShadowColor,
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    left: 12,
                                  ),
                                  children: [
                                    BenefitsListCategoryCardContent(
                                      model: model,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
