import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/resale_detail_page/components/components.dart';
import 'package:hr_tcc/presentation/pages/resale_widget/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import '../../navigation/navigation.dart';

class ResaleDetailPage extends StatelessWidget {
  const ResaleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ResaleDetailView();
  }
}

class _ResaleDetailView extends StatelessWidget {
  const _ResaleDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResaleDetailPageBloc, ResaleDetailPageState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppNavigationBar(
                title: '',
                leftIconAsset: Assets.icons.navigationBar.back.path,
              ),
              body: ListView(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                  bottom: 132,
                ),
                children: [
                  GestureDetector(
                    onTap: () {
                      appShowModularSheet(
                        headerHeight: 60,
                        context: context,
                        title: 'История изменения статусов',
                        titleStyle: AppTypography.title4Bold,
                        content: ResailDetailBookingListCell(
                          items: state.bookingsHistory,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        OnSaleBadge(
                          model: OnSaleBadgeModel.fromStatus(
                            SaleStatus.reserved,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          state.lastStatusChangeText,
                          style: AppTypography.caption2Medium.copyWith(
                            color: AppColors.gray700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ResaleImageCarousel(imagePaths: state.imagePaths),
                  const SizedBox(height: 12),
                  Text(state.price, style: AppTypography.title2Bold),
                  const SizedBox(height: 8),
                  Text(state.title, style: AppTypography.text1Semibold),
                  const SizedBox(height: 16),
                  if (state.fileURL != null && state.fileName != null) ...[
                    ResaleDownloadFileButton(
                      fileName: state.fileName ?? '',
                      onTap: () {
                        context.read<ResaleDetailPageBloc>().add(
                          OnTapResaleDownloadButton(
                            fileURL: state.fileURL ?? '',
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                  ...state.details.map(
                    (e) => ResailDetailInfoTextBlock(label: e.$1, value: e.$2),
                  ),
                  ResaleMesagesCount(
                    count: state.messagesCount,
                    onTap:
                        () => {
                          context.push(
                            AppRoute.chat.path,
                            extra: {
                              'title': 'Лента активности',
                              'subTitle': 'Ресейл «Audi A6»',
                            },
                          ),
                        },
                  ),
                ],
              ),
            ),
            AppFlostingBottomBar(
              child: AppResaleLockButton(
                isLocked: state.isLocked,
                onPressed: () {
                  context.read<ResaleDetailPageBloc>().add(
                    ToggleLockResaleDetailPage(),
                  );
                },
                height: 52,
                borderRadius: 12,
                textStyle: AppTypography.button1Medium,
              ),
            ),
          ],
        );
      },
    );
  }
}
