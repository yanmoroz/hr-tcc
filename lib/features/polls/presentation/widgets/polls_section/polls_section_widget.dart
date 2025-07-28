import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/themes/themes.dart';
import '../../../../../presentation/blocs/blocs.dart';
import '../../../../../presentation/navigation/navigation.dart';
import '../../../../../presentation/widgets/common/common.dart';
import 'subwidgets/poll_card.dart';

class PollsSectionWidget extends StatelessWidget {
  const PollsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocFactory.createPollsSectionBloc()..add(LoadPolls()),
      child: BlocBuilder<PollsSectionBloc, PollsSectionState>(
        builder: (context, state) {
          if (state is PollsSectionLoaded) {
            return VerticalSection(
              title: 'Опросы',
              moreButtonText: 'Перейти в раздел',
              onSeeAll: () {
                context.push(AppRoute.polls.path);
              },
              cards:
                  state.polls.map((poll) {
                    return AppInfoCard(
                      color: AppColors.white,
                      shadowColor: AppColors.cardShadowColor,
                      children: [
                        PollCard(
                          poll: poll,
                          onTap: () {
                            context.push(AppRoute.polls.path);
                          },
                        ),
                      ],
                    );
                  }).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
