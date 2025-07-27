import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/data/repositories/unplanned_training_request_repository_mock.dart';
import 'package:hr_tcc/domain/usecases/create_unplanned_training_request_usecase.dart';
import 'package:hr_tcc/presentation/blocs/unplanned_training_request/unplanned_training_request_bloc.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/presentation/blocs/employees/employees_bloc.dart';
import 'package:hr_tcc/domain/usecases/fetch_courier_request_data_usecase.dart';
import 'package:hr_tcc/domain/repositories/courier_request_repository_mock.dart';
import 'package:hr_tcc/presentation/pages/requests/unplanned_training_request_create_page/components/components.dart';

class UnplannedTrainingRequestCreatePage extends StatelessWidget {
  const UnplannedTrainingRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => UnplannedTrainingRequestBloc(
                CreateUnplannedTrainingRequestUseCase(
                  UnplannedTrainingRequestRepositoryMock(),
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => EmployeesBloc(
                FetchCourierRequestDataUseCase(CourierRequestRepositoryMock()),
              )..add(LoadEmployees()),
        ),
      ],
      child: const _UnplannedTrainingRequestForm(),
    );
  }
}

class _UnplannedTrainingRequestForm extends StatefulWidget {
  const _UnplannedTrainingRequestForm();

  @override
  State<_UnplannedTrainingRequestForm> createState() =>
      _UnplannedTrainingRequestFormState();
}

class _UnplannedTrainingRequestFormState
    extends State<_UnplannedTrainingRequestForm> {
  final _formKey = GlobalKey<FormState>();
  late final UnplannedTrainingRequestControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = UnplannedTrainingRequestControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllers.addBlurListeners(context);
    });
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      UnplannedTrainingRequestBloc,
      UnplannedTrainingRequestState
    >(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess && context.mounted) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<
        UnplannedTrainingRequestBloc,
        UnplannedTrainingRequestState
      >(
        builder: (context, state) {
          final bloc = context.read<UnplannedTrainingRequestBloc>();
          final fields = state.fields;
          final errors = state.errors;

          // Синхронизация контроллеров
          void syncController(UnplannedTrainingRequestField field) {
            final controller = _controllers.textControllers[field]!;
            final value = fields[field] ?? '';
            if (controller.text != value) {
              controller.text = value;
            }
          }

          syncController(UnplannedTrainingRequestField.eventName);
          syncController(UnplannedTrainingRequestField.organizerName);
          syncController(UnplannedTrainingRequestField.cost);
          syncController(UnplannedTrainingRequestField.goal);
          syncController(UnplannedTrainingRequestField.courseLink);

          return Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  appBar: const RequestCreationAppBar(title: 'Создание заявки'),
                  backgroundColor: AppColors.white,
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Незапланированное обучение',
                            style: AppTypography.title2Bold,
                          ),
                          const Gap(24),
                          ManagerApproverSection(
                            fields: fields,
                            errors: errors,
                            onChanged:
                                (field, value) => bloc.add(
                                  UnplannedTrainingFieldChanged(field, value),
                                ),
                          ),
                          const Gap(24),
                          TrainingMainSection(
                            fields: fields,
                            errors: errors,
                            controllers: _controllers,
                            onChanged:
                                (field, value) => bloc.add(
                                  UnplannedTrainingFieldChanged(field, value),
                                ),
                          ),
                          const Gap(12),
                          TrainingDetailsSection(
                            fields: fields,
                            errors: errors,
                            controllers: _controllers,
                            onChanged:
                                (field, value) => bloc.add(
                                  UnplannedTrainingFieldChanged(field, value),
                                ),
                          ),
                          const Gap(24),
                          BlocBuilder<EmployeesBloc, EmployeesState>(
                            builder:
                                (context, empState) => EmployeesSection(
                                  fields: fields,
                                  errors: errors,
                                  empState: empState,
                                  onChanged:
                                      (field, value) => bloc.add(
                                        UnplannedTrainingFieldChanged(
                                          field,
                                          value,
                                        ),
                                      ),
                                ),
                          ),
                          const Gap(24),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
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
                        UnplannedTrainingRequestBloc,
                        UnplannedTrainingRequestState
                      >(
                        formKey: _formKey,
                        onSubmit: (context) {
                          FocusScope.of(context).unfocus();
                          context.read<UnplannedTrainingRequestBloc>().add(
                            UnplannedTrainingSubmit(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (state.isSubmitting)
                Container(
                  color: Colors.black.withValues(alpha: 0.15),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
