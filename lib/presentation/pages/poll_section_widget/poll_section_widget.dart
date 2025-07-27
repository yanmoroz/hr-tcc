import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/themes/themes.dart';
import '../../blocs/blocs.dart';
import '../../navigation/navigation.dart';
import '../../widgets/common/common.dart';
import 'components/components.dart';

class PollSectionWidget extends StatelessWidget {
  const PollSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocFactory.createPollSectionBloc()..add(LoadPolls()),
      child: BlocBuilder<PollSectionBloc, PollSectionState>(
        builder: (context, state) {
          if (state is PollSectionLoaded) {
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
                        PollContentCard(
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
