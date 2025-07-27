import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import '../../../../config/themes/themes.dart';
import '../../../../data/repositories/business_trip_request_repository_mock.dart';
import '../../../../data/repositories/employee_repository_mock.dart';
import '../../../../domain/entities/entities.dart';
import '../../../../domain/entities/requests/business_trip_request.dart';
import '../../../../domain/models/requests/requests.dart';
import '../../../../domain/usecases/create_business_trip_request_usecase.dart';
import '../../../../domain/usecases/get_employees_usecase.dart';
import '../../../blocs/blocs.dart';
import '../../../widgets/common/common.dart';
import '../components/components.dart';

class BusinessTripRequestCreatePage extends StatelessWidget {
  const BusinessTripRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => BusinessTripRequestBloc(
            CreateBusinessTripRequestUseCase(
              BusinessTripRequestRepositoryMock(),
            ),
            GetEmployeesUseCase(EmployeeRepositoryMock()),
          ),
      child: const _BusinessTripRequestForm(),
    );
  }
}

class _BusinessTripRequestForm extends StatefulWidget {
  const _BusinessTripRequestForm();

  @override
  State<_BusinessTripRequestForm> createState() =>
      _BusinessTripRequestFormState();
}

class _BusinessTripRequestFormState extends State<_BusinessTripRequestForm> {
  final _formKey = GlobalKey<FormState>();
  bool _showComment = false;

  late final TextEditingController _plannedEventsController;
  late final FocusNode _plannedEventsFocusNode;
  late final TextEditingController _commentController;
  late final FocusNode _commentFocusNode;
  late final TextEditingController _purposeDescriptionController;
  late final FocusNode _purposeDescriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _plannedEventsController = TextEditingController();
    _plannedEventsFocusNode = FocusNode();
    _plannedEventsFocusNode.addListener(() {
      if (!_plannedEventsFocusNode.hasFocus) {
        context.read<BusinessTripRequestBloc>().add(
          BusinessTripRequestFieldBlurred(
            BusinessTripRequestField.plannedEvents,
          ),
        );
      }
    });
    _commentController = TextEditingController();
    _commentFocusNode = FocusNode();
    _commentFocusNode.addListener(() {
      if (!_commentFocusNode.hasFocus) {
        context.read<BusinessTripRequestBloc>().add(
          BusinessTripRequestFieldBlurred(BusinessTripRequestField.comment),
        );
      }
    });
    _purposeDescriptionController = TextEditingController();
    _purposeDescriptionFocusNode = FocusNode();
    _purposeDescriptionFocusNode.addListener(() {
      if (!_purposeDescriptionFocusNode.hasFocus) {
        context.read<BusinessTripRequestBloc>().add(
          BusinessTripRequestFieldBlurred(
            BusinessTripRequestField.purposeDescription,
          ),
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessTripRequestBloc>().add(
        BusinessTripRequestLoadEmployees(),
      );
    });
  }

  @override
  void dispose() {
    _plannedEventsController.dispose();
    _plannedEventsFocusNode.dispose();
    _commentController.dispose();
    _commentFocusNode.dispose();
    _purposeDescriptionController.dispose();
    _purposeDescriptionFocusNode.dispose();
    super.dispose();
  }

  bool _showError(
    BusinessTripRequestState state,
    BusinessTripRequestField field,
  ) {
    return (state.submitted || state.errors.containsKey(field));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BusinessTripRequestBloc, BusinessTripRequestState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess && context.mounted) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<BusinessTripRequestBloc, BusinessTripRequestState>(
        builder: (context, state) {
          final bloc = context.read<BusinessTripRequestBloc>();
          final fields = state.fields;
          final errors = state.errors;
          // Синхронизируем контроллеры с состоянием
          if (_plannedEventsController.text !=
              (fields[BusinessTripRequestField.plannedEvents] ?? '')) {
            _plannedEventsController.text =
                fields[BusinessTripRequestField.plannedEvents] ?? '';
            _plannedEventsController.selection = TextSelection.fromPosition(
              TextPosition(offset: _plannedEventsController.text.length),
            );
          }
          if (_commentController.text !=
              (fields[BusinessTripRequestField.comment] ?? '')) {
            _commentController.text =
                fields[BusinessTripRequestField.comment] ?? '';
            _commentController.selection = TextSelection.fromPosition(
              TextPosition(offset: _commentController.text.length),
            );
          }
          if (_purposeDescriptionController.text !=
              (fields[BusinessTripRequestField.purposeDescription] ?? '')) {
            _purposeDescriptionController.text =
                fields[BusinessTripRequestField.purposeDescription] ?? '';
            _purposeDescriptionController
                .selection = TextSelection.fromPosition(
              TextPosition(offset: _purposeDescriptionController.text.length),
            );
          }
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Командировка', style: AppTypography.title2Bold),
                        const SizedBox(height: 24),
                        // Период
                        AppDatePickerField(
                          hint: 'Период',
                          mode: AppDatePickerMode.range,
                          rangeValue: fields[BusinessTripRequestField.period],
                          onRangeChanged: (v) {
                            bloc.add(
                              BusinessTripRequestFieldChanged(
                                BusinessTripRequestField.period,
                                v,
                              ),
                            );
                            bloc.add(
                              BusinessTripRequestFieldBlurred(
                                BusinessTripRequestField.period,
                              ),
                            );
                          },
                          errorText:
                              _showError(state, BusinessTripRequestField.period)
                                  ? errors[BusinessTripRequestField.period]
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        // Откуда
                        AppModalSelector<BusinessTripCity>(
                          title: 'Откуда',
                          items: businessTripCities,
                          selected: fields[BusinessTripRequestField.fromCity],
                          itemLabel: businessTripCityLabel,
                          onSelected: (v) {
                            bloc.add(
                              BusinessTripRequestFieldChanged(
                                BusinessTripRequestField.fromCity,
                                v,
                              ),
                            );
                            bloc.add(
                              BusinessTripRequestFieldBlurred(
                                BusinessTripRequestField.fromCity,
                              ),
                            );
                          },
                          errorText:
                              _showError(
                                    state,
                                    BusinessTripRequestField.fromCity,
                                  )
                                  ? errors[BusinessTripRequestField.fromCity]
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        // Куда
                        AppModalSelector<BusinessTripCity>(
                          title: 'Куда',
                          items: businessTripCities,
                          selected: fields[BusinessTripRequestField.toCity],
                          itemLabel: businessTripCityLabel,
                          onSelected: (v) {
                            bloc.add(
                              BusinessTripRequestFieldChanged(
                                BusinessTripRequestField.toCity,
                                v,
                              ),
                            );
                            bloc.add(
                              BusinessTripRequestFieldBlurred(
                                BusinessTripRequestField.toCity,
                              ),
                            );
                          },
                          errorText:
                              _showError(state, BusinessTripRequestField.toCity)
                                  ? errors[BusinessTripRequestField.toCity]
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        // За чей счет
                        AppModalSelector<BusinessTripAccount>(
                          title: 'За чей счет',
                          items: businessTripAccounts,
                          selected: fields[BusinessTripRequestField.account],
                          itemLabel: businessTripAccountLabel,
                          onSelected: (v) {
                            bloc.add(
                              BusinessTripRequestFieldChanged(
                                BusinessTripRequestField.account,
                                v,
                              ),
                            );
                            bloc.add(
                              BusinessTripRequestFieldBlurred(
                                BusinessTripRequestField.account,
                              ),
                            );
                          },
                          errorText:
                              _showError(
                                    state,
                                    BusinessTripRequestField.account,
                                  )
                                  ? errors[BusinessTripRequestField.account]
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        // Цель
                        AppModalSelector<BusinessTripPurpose>(
                          title: 'Цель',
                          items: businessTripPurposes,
                          selected: fields[BusinessTripRequestField.purpose],
                          itemLabel: businessTripPurposeLabel,
                          onSelected: (v) {
                            bloc.add(
                              BusinessTripRequestFieldChanged(
                                BusinessTripRequestField.purpose,
                                v,
                              ),
                            );
                            bloc.add(
                              BusinessTripRequestFieldBlurred(
                                BusinessTripRequestField.purpose,
                              ),
                            );
                          },
                          errorText:
                              _showError(
                                    state,
                                    BusinessTripRequestField.purpose,
                                  )
                                  ? errors[BusinessTripRequestField.purpose]
                                  : null,
                        ),
                        if (fields[BusinessTripRequestField.purpose] ==
                            BusinessTripPurpose.other)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: AppTextArea(
                              hint: 'Текстовое описание цели',
                              controller: _purposeDescriptionController,
                              focusNode: _purposeDescriptionFocusNode,
                              onChanged: (v) {
                                bloc.add(
                                  BusinessTripRequestFieldChanged(
                                    BusinessTripRequestField.purposeDescription,
                                    v,
                                  ),
                                );
                              },
                              errorText:
                                  _showError(
                                        state,
                                        BusinessTripRequestField
                                            .purposeDescription,
                                      )
                                      ? errors[BusinessTripRequestField
                                          .purposeDescription]
                                      : null,
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Цель по виду деятельности
                        AppModalSelector<BusinessTripActivity>(
                          title: 'Цель по виду деятельности',
                          items: businessTripActivities,
                          selected: fields[BusinessTripRequestField.activity],
                          itemLabel: businessTripActivityLabel,
                          onSelected: (v) {
                            bloc.add(
                              BusinessTripRequestFieldChanged(
                                BusinessTripRequestField.activity,
                                v,
                              ),
                            );
                            bloc.add(
                              BusinessTripRequestFieldBlurred(
                                BusinessTripRequestField.activity,
                              ),
                            );
                          },
                          errorText:
                              _showError(
                                    state,
                                    BusinessTripRequestField.activity,
                                  )
                                  ? errors[BusinessTripRequestField.activity]
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        // Планируемые мероприятия
                        AppTextArea(
                          hint: 'Планируемые мероприятия',
                          controller: _plannedEventsController,
                          focusNode: _plannedEventsFocusNode,
                          onChanged: (v) {
                            bloc.add(
                              BusinessTripRequestFieldChanged(
                                BusinessTripRequestField.plannedEvents,
                                v,
                              ),
                            );
                          },
                          errorText:
                              _showError(
                                    state,
                                    BusinessTripRequestField.plannedEvents,
                                  )
                                  ? errors[BusinessTripRequestField
                                      .plannedEvents]
                                  : null,
                        ),
                        const Gap(16),
                        // Подбор услуг тревел-координатором
                        Text(
                          'Подбор услуг по командировке тревел-координатором',
                          style: AppTypography.text1Medium.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        const Gap(16),
                        AppRadioSwitcher<TravelCoordinatorService>(
                          items: [
                            AppRadioSwitcherItem(
                              value: TravelCoordinatorService.required,
                              label: travelCoordinatorServiceLabel(
                                TravelCoordinatorService.required,
                              ),
                            ),
                            AppRadioSwitcherItem(
                              value: TravelCoordinatorService.notRequired,
                              label: travelCoordinatorServiceLabel(
                                TravelCoordinatorService.notRequired,
                              ),
                            ),
                          ],
                          groupValue:
                              fields[BusinessTripRequestField
                                  .coordinatorService],
                          onChanged: (v) {
                            bloc.add(
                              BusinessTripRequestFieldChanged(
                                BusinessTripRequestField.coordinatorService,
                                v,
                              ),
                            );
                            bloc.add(
                              BusinessTripRequestFieldBlurred(
                                BusinessTripRequestField.coordinatorService,
                              ),
                            );
                          },
                        ),
                        if (_showError(
                              state,
                              BusinessTripRequestField.coordinatorService,
                            ) &&
                            errors[BusinessTripRequestField
                                    .coordinatorService] !=
                                null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(
                              errors[BusinessTripRequestField
                                  .coordinatorService]!,
                              style: AppTypography.text2Regular.copyWith(
                                color: AppColors.red500,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Добавить комментарий (переключатель)
                        AppSwitch(
                          label: 'Добавить комментарий',
                          value: _showComment,
                          onChanged: (v) {
                            setState(() => _showComment = v);
                            if (!v) {
                              bloc.add(
                                BusinessTripRequestFieldChanged(
                                  BusinessTripRequestField.comment,
                                  '',
                                ),
                              );
                            }
                          },
                        ),
                        const Gap(16),
                        if (_showComment)
                          AppTextArea(
                            hint: 'Комментарий',
                            controller: _commentController,
                            focusNode: _commentFocusNode,
                            onChanged: (v) {
                              bloc.add(
                                BusinessTripRequestFieldChanged(
                                  BusinessTripRequestField.comment,
                                  v,
                                ),
                              );
                            },
                          ),
                        const Gap(24),
                        ...[
                          if (state.employeesLoading)
                            const Center(child: CircularProgressIndicator()),
                          if (!state.employeesLoading &&
                              state.employeesError != null)
                            Text(
                              'Ошибка загрузки сотрудников: ${state.employeesError}',
                            ),
                          if (!state.employeesLoading &&
                              state.employeesError == null)
                            EmployeeListSelector<Employee>(
                              title: 'Командируемые',
                              addButtonText: 'Добавить командируемого',
                              allEmployees: state.employees,
                              selectedEmployees:
                                  (fields[BusinessTripRequestField.participants]
                                          as List<Employee>? ??
                                      []),
                              itemLabel: (e) => e.fullName,
                              subtitleLabel: (e) => e.role,
                              onAdd: (_) {},
                              onRemove: (e) {
                                final updated = List<Employee>.from(
                                  fields[BusinessTripRequestField
                                          .participants] ??
                                      [],
                                );
                                updated.remove(e);
                                bloc.add(
                                  BusinessTripRequestFieldChanged(
                                    BusinessTripRequestField.participants,
                                    updated,
                                  ),
                                );
                                bloc.add(
                                  BusinessTripRequestFieldBlurred(
                                    BusinessTripRequestField.participants,
                                  ),
                                );
                              },
                              onChanged: (list) {
                                bloc.add(
                                  BusinessTripRequestFieldChanged(
                                    BusinessTripRequestField.participants,
                                    list,
                                  ),
                                );
                                bloc.add(
                                  BusinessTripRequestFieldBlurred(
                                    BusinessTripRequestField.participants,
                                  ),
                                );
                              },
                              errorText:
                                  _showError(
                                        state,
                                        BusinessTripRequestField.participants,
                                      )
                                      ? errors[BusinessTripRequestField
                                          .participants]
                                      : null,
                              multiple: true,
                            ),
                        ],
                      ],
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
                        BusinessTripRequestBloc,
                        BusinessTripRequestState
                      >(
                        formKey: _formKey,
                        onSubmit: (context) {
                          FocusScope.of(context).unfocus();
                          context.read<BusinessTripRequestBloc>().add(
                            BusinessTripRequestSubmitted(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (state.loading)
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
