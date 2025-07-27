import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/app_colors.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/navigation/app_route.dart';
import 'package:hr_tcc/presentation/pages/benefits_list_categories_page/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class BenefitsListCategoriesPage extends StatelessWidget {
  const BenefitsListCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Льготы и возможности',
        leftIconAsset: Assets.icons.navigationBar.back.path,
      ),
      backgroundColor: AppColors.gray100,
      body: SafeArea(
        child: BlocBuilder<
          BenefitsListCategoriesPageBloc,
          BenefitsListCategoriesPageState
        >(
          builder: (context, state) {
            if (state is BenefitsListCategoriesPageLoaded) {
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
                                  context.push(
                                    AppRoute.benefitsCategoryWithCategory(
                                      model.category.name,
                                    ),
                                  );
                                },
                                child: AppInfoCard(
                                  gradient: AppColors.gradientCardBenefits,
                                  shadowColor: AppColors.cardShadowColor,
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    left: 12,
                                  ),
                                  children: [
                                    BenefitsListCategoriesCardContent(
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
