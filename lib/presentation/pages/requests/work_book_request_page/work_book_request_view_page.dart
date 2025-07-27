import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';

class WorkBookRequestViewPage extends StatelessWidget {
  final String requestId;
  const WorkBookRequestViewPage({required this.requestId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              BlocFactory.createWorkBookRequestViewBloc()
                ..add(LoadWorkBookRequestDetails(requestId)),
      child: const _WorkBookRequestView(),
    );
  }
}

class _WorkBookRequestView extends StatelessWidget {
  const _WorkBookRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RequestAppBar(title: 'Заявка'),
      backgroundColor: AppColors.white,
      body: BlocBuilder<WorkBookRequestViewBloc, WorkBookRequestViewState>(
        builder: (context, state) {
          if (state is WorkBookRequestViewLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkBookRequestViewError) {
            return Center(child: Text(state.message));
          }
          if (state is WorkBookRequestViewLoaded) {
            final request = state.details;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                RequestStatusDateRow(
                  status: StatusChip(status: request.status),
                  date: request.createdAt,
                ),
                const Gap(12),
                Text(
                  'Копия трудовой книжки',
                  style: AppTypography.title2Bold.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const Gap(24),
                const SectionLabel('Цель справки'),
                Text(request.purpose.label, style: AppTypography.text1Regular),
                const Gap(16),
                const SectionLabel('Срок получения'),
                Text(
                  WorkBookRequestViewBloc.formatDate(request.receiveDate),
                  style: AppTypography.text1Regular,
                ),
                const Gap(24),
                if (request.isCertifiedCopy) ...[
                  Text(
                    'Заверенная «Копия верна»',
                    style: AppTypography.text1Medium,
                  ),
                  const Gap(24),
                ],
                if (request.isScanByEmail) ...[
                  Text(
                    'Копия (скан по почте)',
                    style: AppTypography.text1Medium,
                  ),
                ],
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
