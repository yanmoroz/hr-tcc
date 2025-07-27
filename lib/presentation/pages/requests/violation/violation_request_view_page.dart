import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/presentation/blocs/violation_request/violation_request_view_bloc.dart';
import 'package:hr_tcc/domain/usecases/get_violation_request_usecase.dart';
import 'package:hr_tcc/data/repositories/violation_request_repository_mock.dart';

class ViolationRequestViewPage extends StatelessWidget {
  final String requestId;
  const ViolationRequestViewPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ViolationRequestViewBloc(
            GetViolationRequestUseCase(ViolationRequestRepositoryMock()),
          )..add(LoadViolationRequestDetails(requestId)),
      child: const _ViolationRequestView(),
    );
  }
}

class _ViolationRequestView extends StatelessWidget {
  const _ViolationRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RequestAppBar(title: 'Заявка'),
      backgroundColor: AppColors.white,
      body: BlocBuilder<ViolationRequestViewBloc, ViolationRequestViewState>(
        builder: (context, state) {
          if (state is ViolationRequestViewLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ViolationRequestViewError) {
            return Center(child: Text(state.message));
          }
          if (state is ViolationRequestViewLoaded) {
            final request = state.details;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                RequestStatusDateRow(
                  status: StatusChip(status: request.status),
                  date: request.createdAt,
                ),
                const Gap(20),
                Text(
                  'Нарушение',
                  style: AppTypography.title1Bold.copyWith(
                    color: AppColors.black,
                  ),
                ),
                if (request.isConfidential) ...[
                  const Gap(12),
                  Text(
                    'Конфиденциальная заявка',
                    style: AppTypography.text1Medium.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
                const Gap(24),
                const SectionLabel('Тема нарушения'),
                const Gap(4),
                Text(
                  request.subject,
                  style: AppTypography.text1Regular.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const Gap(16),
                const SectionLabel('Описание нарушения'),
                const Gap(4),
                Text(
                  request.description,
                  style: AppTypography.text1Regular.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const Gap(24),
                AppFileGrid(
                  title: 'Файлы',
                  files: request.files,
                  mode: AppFileGridMode.view,
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
