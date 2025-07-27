import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/navigation/navigation.dart';
import 'package:hr_tcc/presentation/pages/resale_widget/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class ResaleWidget extends StatelessWidget {
  const ResaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              BlocFactory.createResaleWidgetBloc()
                ..add(LoadResaleWidgetItems()),
      child: BlocListener<ResaleWidgetBloc, ResaleWidgetState>(
        listener: (context, state) {
          if (state is ResaleWidgetLoaded && state.title != null) {
            AlertManager.show(
              context,
              state.title ?? '',
              AlertPosition.bottom,
              PopUpAlertContent(
                image: state.icon ?? Assets.icons.resale.statusOk.path,
                text: state.title ?? '',
                subtitle: state.subTitle ?? '',
              ),
            );
          }
        },
        child: BlocBuilder<ResaleWidgetBloc, ResaleWidgetState>(
          builder: (context, state) {
            if (state is ResaleWidgetInitial || state is ResaleWidgetLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ResaleWidgetLoaded) {
              return AppHorizontalSection(
                title: 'Ресейл',
                moreButtonText: 'Перейти в раздел',
                onSeeAll: () {
                  context.push(AppRoute.resaleList.path);
                },
                cards:
                    state.items.map((item) {
                      return GestureDetector(
                        onTap: () {
                          context.push(AppRoute.resaleDetail.path);
                        },
                        child: ResaleCardWidget(
                          imageUrl: item.imageUrl,
                          price: item.price,
                          description: item.title,
                          saleStatus: item.status,
                          onTapLock: () {
                            context.read<ResaleWidgetBloc>().add(
                              ToggleLockResaleWidgetStatus(item.id),
                            );
                          },
                        ),
                      );
                    }).toList(),
              );
            } else if (state is ResaleWidgetError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
