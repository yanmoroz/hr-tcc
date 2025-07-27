import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/data/repositories/referral_program_request_repository_mock.dart';
import 'package:hr_tcc/presentation/widgets/common/app_file_grid/app_file_grid.dart';
import 'package:hr_tcc/domain/usecases/get_referral_program_request_by_id_usecase.dart';
import 'package:hr_tcc/presentation/pages/requests/components/request_app_bar.dart';
import 'package:hr_tcc/presentation/pages/requests/components/request_status_date_row.dart';
import 'package:hr_tcc/presentation/pages/requests/components/section_label.dart';
import 'package:hr_tcc/presentation/pages/requests/components/status_chip.dart';

class ReferralProgramRequestViewPage extends StatelessWidget {
  final String requestId;
  const ReferralProgramRequestViewPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ReferralProgramRequestViewBloc(
            GetReferralProgramRequestByIdUseCase(
              ReferralProgramRequestRepositoryMock(),
            ),
          )..add(LoadReferralProgramRequest(requestId)),
      child: const _ReferralProgramRequestView(),
    );
  }
}

class _ReferralProgramRequestView extends StatelessWidget {
  const _ReferralProgramRequestView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ReferralProgramRequestViewBloc,
      ReferralProgramRequestViewState
    >(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.error != null) {
          return Scaffold(
            appBar: const RequestAppBar(title: 'Заявка'),
            body: Center(child: Text(state.error!)),
          );
        }
        final request = state.request;
        if (request == null) {
          return const Scaffold(
            appBar: RequestAppBar(title: 'Заявка'),
            body: Center(child: Text('Заявка не найдена')),
          );
        }
        final file = request.file;
        final files =
            file != null
                ? [
                  AppFileGridItem(
                    name: file.name,
                    extension: file.extension,
                    sizeBytes: file.size,
                    status: AppFileUploadStatus.success,
                  ),
                ]
                : <AppFileGridItem>[];
        return Scaffold(
          appBar: const RequestAppBar(title: 'Заявка'),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                RequestStatusDateRow(
                  status: StatusChip(status: request.status),
                  date: request.createdAt,
                ),
                const Gap(24),
                const Text(
                  'Реферральная программа',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Gap(24),
                const SectionLabel('Вакансия'),
                Text(
                  request.vacancy.label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Gap(20),
                const SectionLabel('ФИО кандидата'),
                Text(
                  request.candidateName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Gap(20),
                const SectionLabel('Ссылка на резюме'),
                Text(
                  request.resumeLink,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Gap(16),
                AppFileGrid(
                  title: 'Файл резюме',
                  files: files,
                  columns: 3,
                  mode: AppFileGridMode.view,
                  onOpenFile: (item) {},
                ),
                const Gap(16),
                if (request.comment != null && request.comment!.isNotEmpty) ...[
                  const SectionLabel('Комментарий'),
                  Text(
                    request.comment!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
