import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/quick_links_page/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class QuickLinksPage extends StatelessWidget {
  const QuickLinksPage({super.key});

  final backgroundColor = AppColors.gray200;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocFactory.createQuickLinksBloc()..add(LoadQuickLinks()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Быстрые ссылки'),
          elevation: 0,
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
        ),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: BlocBuilder<QuickLinksBloc, QuickLinksState>(
            builder: (context, state) {
              if (state is QuickLinksLoaded) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  children: [
                    AppSectionWithCard(
                      title: '',
                      cards:
                          state.links
                              .map(
                                (quickLink) => GestureDetector(
                                  onTap: () {
                                    context.read<QuickLinksBloc>().add(
                                      QuickLinkClicked(quickLink.url),
                                    );
                                  },
                                  child: AppInfoCard(
                                    color: AppColors.white,
                                    shadowColor: AppColors.cardShadowColor,
                                    children: [
                                      QuickLinkCardContent(
                                        quickLink: quickLink,
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
      ),
    );
  }
}
