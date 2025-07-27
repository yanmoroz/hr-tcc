import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_typography.dart';
import '../../../../../domain/entities/requests/absence_request.dart';
import '../../../../blocs/absence_request/absence_request_view_bloc.dart';
import '../../../../blocs/bloc_factory.dart';
import '../../components/request_app_bar.dart';
import '../../components/request_status_date_row.dart';
import '../../components/section_label.dart';
import '../../components/status_chip.dart';

class AbsenceRequestViewPage extends StatelessWidget {
  final String requestId;
  const AbsenceRequestViewPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              BlocFactory.createAbsenceRequestViewBloc()
                ..add(LoadAbsenceRequestDetails(requestId)),
      child: const _AbsenceRequestView(),
    );
  }
}

class _AbsenceRequestView extends StatelessWidget {
  const _AbsenceRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RequestAppBar(title: 'Заявка'),
      backgroundColor: AppColors.white,
      body: BlocBuilder<AbsenceRequestViewBloc, AbsenceRequestViewState>(
        builder: (context, state) {
          if (state is AbsenceRequestViewLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AbsenceRequestViewError) {
            return Center(child: Text(state.message));
          }
          if (state is AbsenceRequestViewLoaded) {
            final d = state.details;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                RequestStatusDateRow(
                  status: StatusChip(status: d.status),
                  date: d.createdAt,
                ),
                const Gap(24),
                Text('Отсутствие', style: AppTypography.title2Bold),
                const Gap(24),
                const SectionLabel('Тип'),
                Text(d.type.label, style: AppTypography.text1Regular),
                const Gap(20),
                if (d.type == AbsenceType.earlyLeave ||
                    d.type == AbsenceType.lateArrival ||
                    d.type == AbsenceType.other) ...[
                  const SectionLabel('Дата или период'),
                  Text(
                    _formatDate(d.date ?? DateTime.now()),
                    style: AppTypography.text1Regular,
                  ),
                  const Gap(20),
                ],
                if (d.type == AbsenceType.workSchedule && d.period != null) ...[
                  const SectionLabel('Дата или период'),
                  Text(
                    '${_formatDate(d.period!.start)} - ${_formatDate(d.period!.end)}',
                    style: AppTypography.text1Regular,
                  ),
                  const Gap(20),
                ],
                if (d.type == AbsenceType.earlyLeave ||
                    d.type == AbsenceType.lateArrival) ...[
                  const SectionLabel('Время'),
                  Text(
                    _formatTime(context, d.time),
                    style: AppTypography.text1Regular,
                  ),
                  const Gap(20),
                ],
                if (d.type == AbsenceType.workSchedule) ...[
                  const SectionLabel('График работы, часы «С»'),
                  Text(
                    _formatTime(context, d.timeRangeStart),
                    style: AppTypography.text1Regular,
                  ),
                  const Gap(20),
                  const SectionLabel('График работы, часы «До»'),
                  Text(
                    _formatTime(context, d.timeRangeEnd),
                    style: AppTypography.text1Regular,
                  ),
                  const Gap(20),
                ],
                if (d.reason != null && d.reason!.isNotEmpty) ...[
                  const SectionLabel('Причина'),
                  Text(d.reason!, style: AppTypography.text1Regular),
                  const Gap(20),
                ],
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  String _formatTime(BuildContext context, TimeOfDay? t) {
    if (t == null) return '';
    return t.format(context);
  }
}
