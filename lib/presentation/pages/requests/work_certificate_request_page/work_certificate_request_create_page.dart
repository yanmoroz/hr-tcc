import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/presentation/blocs/work_certificate_request/work_certificate_request_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/models/requests/work_certificate_request_models.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:flutter/services.dart';

class WorkCertificateRequestCreatePage extends StatelessWidget {
  const WorkCertificateRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkCertificateRequestBloc(),
      child: const _WorkCertificateRequestCreateView(),
    );
  }
}

class _WorkCertificateRequestCreateView extends StatefulWidget {
  const _WorkCertificateRequestCreateView();
  @override
  State<_WorkCertificateRequestCreateView> createState() =>
      _WorkCertificateRequestCreateViewState();
}

class _WorkCertificateRequestCreateViewState
    extends State<_WorkCertificateRequestCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _copiesController = TextEditingController();

  @override
  void dispose() {
    _copiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      WorkCertificateRequestBloc,
      WorkCertificateRequestState
    >(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<
        WorkCertificateRequestBloc,
        WorkCertificateRequestState
      >(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.white,
                appBar: const RequestCreationAppBar(title: 'Создание заявки'),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Справка с места работы',
                              style: AppTypography.title2Bold,
                            ),
                            const Gap(24),
                            _PurposeDropdown(),
                            const Gap(16),
                            _ReceiveDatePicker(),
                            const Gap(8),
                            const SectionLabel(
                              'Справка готовится в течение 3-х рабочих дней',
                            ),
                            const Gap(16),
                            _CopiesCountField(controller: _copiesController),
                            const Gap(32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D343D57), // #343D57, 5%
                        offset: Offset(0, -4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: SafeArea(
                    minimum: const EdgeInsets.all(16),
                    child: SubmitButtonSection<
                      WorkCertificateRequestBloc,
                      WorkCertificateRequestState
                    >(
                      formKey: _formKey,
                      onSubmit: (context) {
                        FocusScope.of(context).unfocus();
                        context.read<WorkCertificateRequestBloc>().add(
                          WorkCertificateRequestSubmit(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (state.isSubmitting)
                Container(
                  color: AppColors.black.withValues(alpha: 0.15),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PurposeDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkCertificateRequestBloc, WorkCertificateRequestState>(
      builder: (context, state) {
        final error = state.errors[WorkCertificateRequestField.purpose];
        final value =
            state.fields[WorkCertificateRequestField.purpose]
                as WorkCertificatePurpose?;
        return AppModalSelector<WorkCertificatePurpose>(
          title: 'Цель справки',
          items: WorkCertificatePurpose.values,
          selected: value,
          itemLabel: (purpose) => purpose.label,
          onSelected: (purpose) {
            context.read<WorkCertificateRequestBloc>().add(
              WorkCertificateRequestFieldChanged(
                WorkCertificateRequestField.purpose,
                purpose,
              ),
            );
            context.read<WorkCertificateRequestBloc>().add(
              WorkCertificateRequestFieldBlurred(
                WorkCertificateRequestField.purpose,
              ),
            );
          },
          errorText: error,
        );
      },
    );
  }
}

class _ReceiveDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkCertificateRequestBloc, WorkCertificateRequestState>(
      builder: (context, state) {
        final error = state.errors[WorkCertificateRequestField.receiveDate];
        final value =
            state.fields[WorkCertificateRequestField.receiveDate] as DateTime?;
        return AppDatePickerField(
          hint: 'Срок получения',
          value: value,
          errorText: error,
          firstDate: DateTime.now().add(const Duration(days: 3)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onChanged: (picked) {
            context.read<WorkCertificateRequestBloc>().add(
              WorkCertificateRequestFieldChanged(
                WorkCertificateRequestField.receiveDate,
                picked,
              ),
            );
            context.read<WorkCertificateRequestBloc>().add(
              WorkCertificateRequestFieldBlurred(
                WorkCertificateRequestField.receiveDate,
              ),
            );
          },
        );
      },
    );
  }
}

class _CopiesCountField extends StatelessWidget {
  final TextEditingController controller;
  const _CopiesCountField({required this.controller});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkCertificateRequestBloc, WorkCertificateRequestState>(
      builder: (context, state) {
        final error = state.errors[WorkCertificateRequestField.copiesCount];
        final value =
            state.fields[WorkCertificateRequestField.copiesCount]?.toString() ??
            '';
        if (controller.text != value) {
          controller.text = value;
        }
        return AppTextField(
          controller: controller,
          keyboardType: TextInputType.number,
          hint: 'Количество экземпляров',
          errorText: error,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) {
            context.read<WorkCertificateRequestBloc>().add(
              WorkCertificateRequestFieldChanged(
                WorkCertificateRequestField.copiesCount,
                val,
              ),
            );
          },
          onSubmitted: (_) {
            context.read<WorkCertificateRequestBloc>().add(
              WorkCertificateRequestFieldBlurred(
                WorkCertificateRequestField.copiesCount,
              ),
            );
          },
        );
      },
    );
  }
}
