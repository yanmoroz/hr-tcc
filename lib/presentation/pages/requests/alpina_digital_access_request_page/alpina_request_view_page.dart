import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/presentation/blocs/alpina_digital_access_request/alpina_request_view_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/repositories/alpina_digital_access_request_repository_mock.dart';
import 'package:hr_tcc/domain/usecases/fetch_alpina_digital_access_request_details_usecase.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';

import '../../../../core/utils/date_utils.dart';

class AlpinaRequestViewPage extends StatelessWidget {
  final String requestId;
  const AlpinaRequestViewPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => AlpinaRequestViewBloc(
            FetchAlpinaDigitalAccessRequestDetailsUseCase(
              AlpinaDigitalAccessRequestRepositoryMock(),
            ),
          )..add(LoadAlpinaDigitalAccessRequestDetails(requestId)),
      child: const _AlpinaRequestViewPageView(),
    );
  }
}

class _AlpinaRequestViewPageView extends StatelessWidget {
  const _AlpinaRequestViewPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RequestAppBar(title: 'Заявка'),
      backgroundColor: AppColors.white,
      body: BlocBuilder<AlpinaRequestViewBloc, AlpinaRequestViewState>(
        builder: (context, state) {
          if (state is AlpinaDigitalAccessRequestLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AlpinaDigitalAccessRequestError) {
            return Center(child: Text(state.message));
          }
          if (state is AlpinaDigitalAccessRequestLoaded) {
            final d = state.details;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                RequestStatusDateRow(
                  status: StatusChip(status: d.status),
                  date: d.createdAt,
                ),
                const Gap(16),
                Text(
                  'Предоставление доступа к «Альпина Диджитал»',
                  style: AppTypography.title2Bold.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const Gap(20),
                const SectionLabel('Срок получения'),
                Text(
                  AppDateUtils.formatDate(d.date),
                  style: AppTypography.text1Regular,
                ),
                const Gap(20),
                const SectionLabel('Был ли ранее вам предоставлен доступ?'),
                Text(
                  d.wasAccessProvided == true ? 'Да' : 'Нет',
                  style: AppTypography.text1Regular,
                ),
                if (d.comment != null && d.comment!.isNotEmpty) ...[
                  const Gap(20),
                  const SectionLabel('Комментарий'),
                  Text(d.comment!, style: AppTypography.text1Regular),
                ],
                const Gap(20),
                const Text(''),
                Text(
                  'Я ознакомлен(а) с информацией о сроке действия ссылки 24 часа и удалении аккаунта при его неиспользовании более 3 месяцев',
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
