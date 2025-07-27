import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/work_certificate_request_models.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/domain/usecases/fetch_work_certificate_request_details_usecase.dart';
import 'package:hr_tcc/domain/repositories/work_certificate_request_repository_mock.dart';
import 'package:hr_tcc/presentation/blocs/work_certificate_request/work_certificate_request_view_bloc.dart';

class WorkCertificateRequestViewPage extends StatelessWidget {
  final String requestId;
  const WorkCertificateRequestViewPage({required this.requestId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => WorkCertificateRequestViewBloc(
            FetchWorkCertificateRequestDetailsUseCase(
              WorkCertificateRequestRepositoryMock(),
            ),
          )..add(LoadWorkCertificateRequestDetails(requestId)),
      child: const _WorkCertificateRequestView(),
    );
  }
}

class _WorkCertificateRequestView extends StatelessWidget {
  const _WorkCertificateRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RequestAppBar(title: 'Заявка'),
      backgroundColor: AppColors.white,
      body: BlocBuilder<
        WorkCertificateRequestViewBloc,
        WorkCertificateRequestViewState
      >(
        builder: (context, state) {
          if (state is WorkCertificateRequestViewLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkCertificateRequestViewError) {
            return Center(child: Text(state.message));
          }
          if (state is WorkCertificateRequestViewLoaded) {
            final request = state.details;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                RequestStatusDateRow(
                  status: StatusChip(status: request.status),
                  date: request.createdAt,
                ),
                const Gap(16),
                Text(
                  'Справка с места работы',
                  style: AppTypography.title2Bold.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const Gap(20),
                const SectionLabel('Цель справки'),
                Text(request.purpose.label, style: AppTypography.text1Regular),
                const Gap(20),
                const SectionLabel('Срок получение'),
                Text(
                  _formatDate(request.receiveDate),
                  style: AppTypography.text1Regular,
                ),
                const Gap(20),
                const SectionLabel('Количество экземпляров'),
                Text(
                  request.copiesCount.toString(),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
