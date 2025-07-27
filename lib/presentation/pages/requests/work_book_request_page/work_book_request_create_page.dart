import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';

class WorkBookRequestCreatePage extends StatelessWidget {
  const WorkBookRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocFactory.createWorkBookRequestBloc(),
      child: const _WorkBookRequestCreateView(),
    );
  }
}

class _WorkBookRequestCreateView extends StatefulWidget {
  const _WorkBookRequestCreateView();
  @override
  State<_WorkBookRequestCreateView> createState() =>
      _WorkBookRequestCreateViewState();
}

class _WorkBookRequestCreateViewState
    extends State<_WorkBookRequestCreateView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkBookRequestBloc, WorkBookRequestState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<WorkBookRequestBloc, WorkBookRequestState>(
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
                      vertical: 8,
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Копия трудовой книжки',
                              style: AppTypography.title2Bold.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            const Gap(24),
                            AppModalSelector<int>(
                              title: 'Количество экземпляров',
                              items: List.generate(5, (i) => i + 1),
                              selected:
                                  state.fields[WorkBookRequestField
                                      .copiesCount],
                              itemLabel: (v) => v.toString(),
                              onSelected: (v) {
                                context.read<WorkBookRequestBloc>().add(
                                  WorkBookRequestFieldChanged(
                                    WorkBookRequestField.copiesCount,
                                    v,
                                  ),
                                );
                                context.read<WorkBookRequestBloc>().add(
                                  WorkBookRequestFieldBlurred(
                                    WorkBookRequestField.copiesCount,
                                  ),
                                );
                              },
                              errorText:
                                  state.errors[WorkBookRequestField
                                      .copiesCount],
                            ),
                            const Gap(16),
                            AppDatePickerField(
                              hint: 'Срок получения',
                              value:
                                  state.fields[WorkBookRequestField
                                      .receiveDate],
                              onChanged: (date) {
                                context.read<WorkBookRequestBloc>().add(
                                  WorkBookRequestFieldChanged(
                                    WorkBookRequestField.receiveDate,
                                    date,
                                  ),
                                );
                                context.read<WorkBookRequestBloc>().add(
                                  WorkBookRequestFieldBlurred(
                                    WorkBookRequestField.receiveDate,
                                  ),
                                );
                              },
                              errorText:
                                  state.errors[WorkBookRequestField
                                      .receiveDate],
                              firstDate: (state.fields[WorkBookRequestField
                                          .receiveDate]
                                      as DateTime)
                                  .subtract(const Duration(days: 1)),
                              mode: AppDatePickerMode.single,
                            ),
                            const Gap(24),
                            AppSwitch(
                              label: 'Заверенная «Копия верна»',
                              value:
                                  state.fields[WorkBookRequestField
                                      .isCertifiedCopy],
                              onChanged:
                                  (v) =>
                                      context.read<WorkBookRequestBloc>().add(
                                        WorkBookRequestFieldChanged(
                                          WorkBookRequestField.isCertifiedCopy,
                                          v,
                                        ),
                                      ),
                            ),
                            const Gap(24),
                            AppSwitch(
                              label: 'Копия (скан по почте)',
                              value:
                                  state.fields[WorkBookRequestField
                                      .isScanByEmail] ??
                                  false,
                              onChanged:
                                  (v) =>
                                      context.read<WorkBookRequestBloc>().add(
                                        WorkBookRequestFieldChanged(
                                          WorkBookRequestField.isScanByEmail,
                                          v,
                                        ),
                                      ),
                            ),
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
                        color: Color(0x0D343D57),
                        offset: Offset(0, -4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: SafeArea(
                    minimum: const EdgeInsets.all(16),
                    child: SubmitButtonSection<
                      WorkBookRequestBloc,
                      WorkBookRequestState
                    >(
                      formKey: _formKey,
                      onSubmit: (context) {
                        FocusScope.of(context).unfocus();
                        context.read<WorkBookRequestBloc>().add(
                          WorkBookRequestSubmit(),
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
