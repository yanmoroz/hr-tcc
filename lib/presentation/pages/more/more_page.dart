import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/app_colors.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/navigation/app_route.dart';
import 'package:hr_tcc/presentation/pages/main_page_wrapper_with_scroll/components/components.dart';
import 'package:hr_tcc/presentation/pages/more/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import '../../../core/logging/app_logger.dart';
import '../../../models/models.dart';

class MorePage extends StatelessWidget {
  final AppLogger _logger = GetIt.I<AppLogger>();

  MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocFactory.createMorePageBloc(),
      child: Scaffold(
        backgroundColor: AppColors.gray200,
        appBar: const UserNavigationBar(
          backgroundColor: AppColors.white,
          cornerRadius: 24,
          height: 80,
          rounded: true,
        ),
        body: BlocBuilder<MorePageBloc, MorePageState>(
          builder: (context, state) {
            if (state is MorePageLoaded) {
              return VerticalSection(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                cards:
                    state.cards
                        .map(
                          (card) => GestureDetector(
                            onTap: () {
                              _onCardTapped(context, card.id);
                            },
                            child: AppInfoCard(
                              color: AppColors.white,
                              shadowColor: AppColors.cardShadowColor,
                              children: [
                                MoreContentCard(
                                  title: card.title,
                                  subTitle: card.subTitle,
                                  badgeTitle: card.badgeTitle,
                                  backgroundBageColor: card.backgroundBageColor,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _onCardTapped(BuildContext context, MoreCardId cardId) {
    switch (cardId) {
      case MoreCardId.violations:
        _logger.i('Нарушения');
      case MoreCardId.quickLinks:
        context.push(AppRoute.quickLinks.path);
      case MoreCardId.resale:
        context.push(AppRoute.resaleDetail.path);
      case MoreCardId.polls:
        context.push(AppRoute.polls.path);
      case MoreCardId.news:
        context.push(AppRoute.news.path);
      case MoreCardId.benefits:
        context.push(AppRoute.benefits.path);
      case MoreCardId.addressBook:
        context.push(AppRoute.addressBook.path);
    }
  }
}
