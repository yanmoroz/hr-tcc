import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/presentation/pages/requests/components/request_app_bar.dart';
import 'package:hr_tcc/presentation/pages/requests/components/status_chip.dart';
import 'package:hr_tcc/presentation/pages/requests/components/section_label.dart';
import 'package:hr_tcc/presentation/pages/requests/components/request_status_date_row.dart';
import 'package:hr_tcc/presentation/blocs/unplanned_training_request/unplanned_training_request_view_bloc.dart';
import 'package:hr_tcc/domain/usecases/get_unplanned_training_request_usecase.dart';
import 'package:hr_tcc/data/repositories/unplanned_training_request_repository_mock.dart';

import '../../../../core/utils/date_utils.dart';

class UnplannedTrainingRequestViewPage extends StatelessWidget {
  final String requestId;
  const UnplannedTrainingRequestViewPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => UnplannedTrainingRequestViewBloc(
            GetUnplannedTrainingRequestUseCase(
              UnplannedTrainingRequestRepositoryMock(),
            ),
          )..add(LoadUnplannedTrainingRequestDetails(requestId)),
      child: const _UnplannedTrainingRequestView(),
    );
  }
}

class _UnplannedTrainingRequestView extends StatelessWidget {
  const _UnplannedTrainingRequestView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      UnplannedTrainingRequestViewBloc,
      UnplannedTrainingRequestViewState
    >(
      builder: (context, state) {
        if (state is UnplannedTrainingRequestViewLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is UnplannedTrainingRequestViewError) {
          return Scaffold(
            appBar: const RequestAppBar(title: 'Заявка'),
            body: Center(child: Text(state.message)),
          );
        }
        if (state is UnplannedTrainingRequestViewLoaded) {
          final req = state.request;
          return Scaffold(
            appBar: const RequestAppBar(title: 'Заявка'),
            backgroundColor: AppColors.white,
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                // Статус и дата
                RequestStatusDateRow(
                  status: StatusChip(status: req.status),
                  date: req.createdAt,
                ),
                const SizedBox(height: 20),
                // Заголовок
                Text(
                  'Незапланированное\nобучение',
                  style: AppTypography.title1Bold,
                ),
                const SizedBox(height: 32),
                // Сотрудники
                Text('Сотрудники', style: AppTypography.title3Semibold),
                const SizedBox(height: 20),
                const SectionLabel('Руководитель'),
                _FieldValue(req.manager),
                const SizedBox(height: 16),
                const SectionLabel('Согласующий'),
                _FieldValue(req.approver),
                const SizedBox(height: 32),
                // Обучение
                Text('Обучение', style: AppTypography.title3Semibold),
                const SizedBox(height: 20),
                const SectionLabel('Организатор'),
                _FieldValue(req.organizer.label),
                if (req.organizer == UnplannedTrainingOrganizer.other &&
                    req.organizerName != null) ...[
                  const SizedBox(height: 16),
                  const SectionLabel('Название организатора'),
                  _FieldValue(req.organizerName!),
                ],
                const SizedBox(height: 16),
                const SectionLabel('Название мероприятия'),
                _FieldValue(req.eventName),
                const SizedBox(height: 16),
                const SectionLabel('Вид обучения'),
                _FieldValue(req.type.label),
                const SizedBox(height: 16),
                const SectionLabel('Форма обучения'),
                _FieldValue(req.form.label),
                const SizedBox(height: 16),
                const SectionLabel('Дата начала обучения'),
                _FieldValue(
                  req.startDate != null
                      ? AppDateUtils.formatDate(req.startDate!)
                      : '-',
                ),
                const SizedBox(height: 16),
                const SectionLabel('Дата окончания обучения'),
                _FieldValue(
                  req.endDate != null
                      ? AppDateUtils.formatDate(req.endDate!)
                      : '-',
                ),
                if (req.unknownDates && req.month != null) ...[
                  const SizedBox(height: 16),
                  const SectionLabel('Месяц'),
                  _FieldValue(req.month!.label),
                ],
                const SizedBox(height: 16),
                const SectionLabel('Стоимость в рублях'),
                _FieldValue(req.cost, bold: true),
                const SizedBox(height: 16),
                const SectionLabel('Цель обучения'),
                _FieldValue(req.goal),
                if (req.courseLink != null && req.courseLink!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const SectionLabel('Ссылка на курс'),
                  _FieldValue(req.courseLink!),
                ],
                const SizedBox(height: 32),
                // Обучающиеся
                Text('Обучающиеся', style: AppTypography.title3Semibold),
                const SizedBox(height: 20),
                ...req.employees.map((e) => _EmployeeRow(e)),
                const SizedBox(height: 24),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _FieldValue extends StatelessWidget {
  final String text;
  final bool bold;
  const _FieldValue(this.text, {this.bold = false});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          bold
              ? AppTypography.text1Medium.copyWith(color: AppColors.black)
              : AppTypography.text1Regular.copyWith(color: AppColors.black),
    );
  }
}

class _EmployeeRow extends StatelessWidget {
  final Employee employee;
  const _EmployeeRow(this.employee);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.fullName,
            style: AppTypography.text1Medium.copyWith(color: AppColors.black),
          ),
          Text(
            employee.role,
            style: AppTypography.text2Regular.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
