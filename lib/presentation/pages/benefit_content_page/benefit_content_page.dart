import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/benefit_content_page/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../navigation/navigation.dart';

class BenefitContentPage extends StatelessWidget {
  const BenefitContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SnackBarWidget(
      child: Scaffold(
        appBar: AppNavigationBar(
          title: '',
          leftIconAsset: Assets.icons.navigationBar.backWhite.path,
          backgroundColor: AppColors.blue300,
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.gradientCardBenefits,
              ),
            ),
            BlocBuilder<BenefitContentBloc, BenefitContentState>(
              builder: (context, state) {
                if (state is BenefitContentLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BenefitContentLoaded) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...state
                            .widgets, // Статичные виджеты заполняются из bloc
                        const SizedBox(height: 16),
                        BenefitsPostStatsRow(
                          likes: state.likeCount,
                          comments: state.commentCount,
                          isLiked: state.isLiked,
                          onLikePressed:
                              () => context.read<BenefitContentBloc>().add(
                                LikePressed(),
                              ),
                          onCommentPressed:
                              () => {
                                context.push(
                                  AppRoute.chat.path,
                                  extra: {
                                    'title': 'Коментарии',
                                    'subTitle': 'ДМС',
                                  },
                                ),
                              },
                        ),
                        const SizedBox(height: 16),
                        ContactButtons(phone: state.phone, email: state.email),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }

                if (state is BenefitContentError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: AppTypography.title2Bold.copyWith(
                        color: AppColors.blue700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
