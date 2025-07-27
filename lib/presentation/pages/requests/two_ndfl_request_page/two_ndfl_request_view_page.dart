import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';

class TwoNdflRequestViewPage extends StatelessWidget {
  final String requestId;
  const TwoNdflRequestViewPage({required this.requestId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return BlocFactory.createTwoNdflRequestViewBloc()
          ..add(LoadTwoNdflRequestDetails(requestId));
      },
      child: const _TwoNdflRequestView(),
    );
  }
}

class _TwoNdflRequestView extends StatelessWidget {
  const _TwoNdflRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RequestAppBar(title: 'Заявка'),
      backgroundColor: AppColors.white,
      body: BlocBuilder<TwoNdflRequestViewBloc, TwoNdflRequestViewState>(
        builder: (context, state) {
          if (state is TwoNdflRequestViewLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TwoNdflRequestViewError) {
            return Center(child: Text(state.message));
          }
          if (state is TwoNdflRequestViewLoaded) {
            final request = state.details;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Text(
                  'Справка 2-НДФЛ',
                  style: AppTypography.title2Bold.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const Gap(24),
                const SectionLabel('Цель справки'),
                const Gap(4),
                Text(request.purpose.label, style: AppTypography.text1Regular),
                const Gap(16),
                const SectionLabel('Период'),
                const Gap(4),
                Text(
                  TwoNdflRequestViewBloc.formatRange(request.period),
                  style: AppTypography.text1Regular,
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
