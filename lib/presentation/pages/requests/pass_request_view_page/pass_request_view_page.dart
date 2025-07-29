import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/entities.dart';
import 'package:hr_tcc/domain/repositories/pass_request_repository_mock.dart';
import 'package:hr_tcc/domain/usecases/get_pass_request_by_id_usecase.dart';
import 'package:hr_tcc/presentation/blocs/pass_request/pass_request_view_bloc.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/config/themes/themes.dart';

import '../../../../core/utils/date_utils.dart';

class PassRequestViewPage extends StatelessWidget {
  final String requestId;
  const PassRequestViewPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => PassRequestViewBloc(
            GetPassRequestByIdUseCase(PassRequestRepositoryMock()),
          )..add(LoadPassRequestDetails(requestId)),
      child: BlocBuilder<PassRequestViewBloc, PassRequestViewState>(
        builder: (context, state) {
          if (state is PassRequestViewLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is PassRequestViewError) {
            return Scaffold(
              appBar: const RequestAppBar(title: 'Заявка'),
              body: Center(child: Text(state.message)),
            );
          }
          if (state is PassRequestViewLoaded) {
            final request = state.details;
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: const RequestAppBar(title: 'Заявка'),
              body: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                children: [
                  RequestStatusDateRow(
                    status: StatusChip(status: request.status),
                    date: request.createdAt,
                  ),
                  const SizedBox(height: 16),
                  Text('Пропуск', style: AppTypography.title1Bold),
                  const SizedBox(height: 24),
                  const SectionLabel('Тип пропуска'),
                  const SizedBox(height: 2),
                  Text(
                    () {
                      switch (request.type) {
                        case PassType.guest:
                          return 'Гостевой пропуск';
                        case PassType.permanent:
                          return 'Постоянный пропуск';
                        case PassType.overtime:
                          return 'Пропуск в нерабочее время';
                        case PassType.contractor:
                          return 'Пропуск сотрудников подрядчика';
                      }
                    }(),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Цель посещения'),
                  const SizedBox(height: 2),
                  Text(
                    request.purpose != null
                        ? passPurposeLabel(request.purpose!)
                        : '—',
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  if (request.purpose == PassPurpose.other &&
                      request.otherPurpose != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      request.otherPurpose!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const SectionLabel('Этаж'),
                  const SizedBox(height: 2),
                  Text(
                    '${request.floor}',
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Офис'),
                  const SizedBox(height: 2),
                  Text(
                    request.office.name,
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Дата или период'),
                  const SizedBox(height: 2),
                  if (request.dateRange != null)
                    Text(
                      AppDateUtils.formatDateRange(request.dateRange!),
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const SectionLabel('Часы «C»'),
                  const SizedBox(height: 2),
                  if (request.timeFrom != null)
                    Text(
                      _formatTime(request.timeFrom!),
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const SectionLabel('Часы «До»'),
                  const SizedBox(height: 2),
                  if (request.timeTo != null)
                    Text(
                      _formatTime(request.timeTo!),
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text('Посетители', style: AppTypography.title2Bold),
                  const SizedBox(height: 8),
                  ...request.visitors.map(
                    (fio) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel('ФИО'),
                        const SizedBox(height: 2),
                        Text(
                          fio,
                          style: AppTypography.text1Regular.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
