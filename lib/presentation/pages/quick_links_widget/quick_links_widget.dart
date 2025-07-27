import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/themes/themes.dart';
import '../../blocs/blocs.dart';
import '../../navigation/navigation.dart';
import 'components/components.dart';

class QuickLinksWidget extends StatelessWidget {
  const QuickLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              BlocFactory.createQuickLinksWidgetBloc()
                ..add(LoadQuickWidgetLinks()),
      child: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Быстрые ссылки',
                  style: AppTypography.text1Semibold,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.push(AppRoute.quickLinks.path);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Перейти в раздел',
                    style: AppTypography.openSectionButtonStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<QuickLinksWidgetBloc, QuickLinksWidgetState>(
              builder: (context, state) {
                if (state is QuickLinksWidgetInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is QuickLinksWidgetLoaded) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        state.links.map((link) {
                          return GestureDetector(
                            onTap: () {
                              context.read<QuickLinksWidgetBloc>().add(
                                QuickLinksWidgetOpenLink(link.url),
                              );
                            },
                            child: QuickLinkCardWidget(link: link),
                          );
                        }).toList(),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
