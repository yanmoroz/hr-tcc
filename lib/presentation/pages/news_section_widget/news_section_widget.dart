import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/navigation/navigation.dart';
import 'package:hr_tcc/presentation/pages/news_section_widget/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

// Widget
class NewsSectionWidget extends StatelessWidget {
  const NewsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => BlocFactory.createNewsSectionBloc()..add(LoadNewsSection()),
      child: BlocBuilder<NewsSectionBloc, NewsSectionState>(
        builder: (context, state) {
          if (state is NewsSectionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsSectionLoaded) {
            return VerticalSection(
              title: 'Новости',
              moreButtonText: 'Перейти в раздел',
              onSeeAll: () {
                context.push(AppRoute.news.path);
              },
              cards:
                  state.news
                      .map(
                        (model) => GestureDetector(
                          onTap:
                              () => {
                                // BlocFactory.createNewsPageBloc()..add(LoadNewsPage()),
                                // NewsPage()
                              },
                          child: AppInfoCard(
                            color: AppColors.white,
                            shadowColor: AppColors.cardShadowColor,
                            children: [NewsContentCard(model: model)],
                          ),
                        ),
                      )
                      .toList(),
            );
          } else if (state is NewsSectionError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
