import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/entities/pass_request.dart';
import 'package:hr_tcc/domain/entities/request_dropdowns.dart';
import 'package:hr_tcc/domain/repositories/pass_request_repository_mock.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/presentation/pages/requests/pass_request_create_page/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/domain/usecases/create_pass_request_usecase.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart'
    hide Office;
import 'package:hr_tcc/domain/usecases/fetch_courier_request_data_usecase.dart';
import 'package:hr_tcc/domain/repositories/courier_request_repository_mock.dart';

class PassRequestCreatePage extends StatelessWidget {
  const PassRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => PassRequestBloc(
                CreatePassRequestUseCase(PassRequestRepositoryMock()),
              ),
        ),
        BlocProvider(
          create:
              (_) => EmployeesBloc(
                FetchCourierRequestDataUseCase(CourierRequestRepositoryMock()),
              )..add(LoadEmployees()),
        ),
      ],
      child: BlocListener<PassRequestBloc, PassRequestState>(
        listenWhen: (prev, curr) => prev.success != curr.success,
        listener: (context, state) {
          if (state.success && context.mounted) {
            FocusScope.of(context).unfocus();
            context.pop(true);
          }
        },
        child: const _PassRequestForm(),
      ),
    );
  }
}

class _PassRequestForm extends StatefulWidget {
  const _PassRequestForm();

  @override
  State<_PassRequestForm> createState() => _PassRequestFormState();
}

class _PassRequestFormState extends State<_PassRequestForm> {
  final _formKey = GlobalKey<FormState>();
  late final PassRequestControllers controllers;
  final TextEditingController _legalEntityController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _workRoomsController = TextEditingController();
  final TextEditingController _equipmentListController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    controllers = PassRequestControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllers.addBlurListeners(context);
    });
  }

  @override
  void dispose() {
    controllers.dispose();
    _legalEntityController.dispose();
    _purposeController.dispose();
    _workRoomsController.dispose();
    _equipmentListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PassRequestBloc, PassRequestState>(
      builder: (context, state) {
        final bloc = context.read<PassRequestBloc>();
        final fields = state.fields;
        final errors = state.errors;
        // Синхронизируем контроллеры с полями state
        if (_workRoomsController.text !=
            (fields[PassRequestField.workRooms] ?? '')) {
          _workRoomsController.text = fields[PassRequestField.workRooms] ?? '';
        }
        if (_equipmentListController.text !=
            (fields[PassRequestField.equipmentList] ?? '')) {
          _equipmentListController.text =
              fields[PassRequestField.equipmentList] ?? '';
        }
        final isOtherPurpose =
            fields[PassRequestField.type] == PassType.overtime ||
            fields[PassRequestField.type] == PassType.contractor;
        final purposeError =
            isOtherPurpose
                ? errors[PassRequestField.otherPurpose]
                : errors[PassRequestField.purpose];
        return Stack(
          children: [
            Scaffold(
              appBar: const RequestCreationAppBar(title: 'Создание заявки'),
              backgroundColor: AppColors.white,
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Пропуск', style: AppTypography.title2Bold),
                      const Gap(24),
                      AppModalSelector<PassType>(
                        title: 'Тип пропуска',
                        items: const [
                          PassType.guest,
                          PassType.permanent,
                          PassType.overtime,
                          PassType.contractor,
                        ],
                        selected: fields[PassRequestField.type],
                        itemLabel: (type) {
                          switch (type) {
                            case PassType.guest:
                              return 'Гостевой пропуск';
                            case PassType.permanent:
                              return 'Постоянный пропуск';
                            case PassType.overtime:
                              return 'Пропуск в нерабочее время';
                            case PassType.contractor:
                              return 'Пропуск сотрудников подрядчика';
                          }
                        },
                        onSelected: (v) {
                          bloc.add(
                            PassRequestFieldChanged(PassRequestField.type, v),
                          );
                          // Сбросить список посетителей при смене типа пропуска
                          if (v == PassType.permanent) {
                            bloc.add(
                              PassRequestFieldChanged(
                                PassRequestField.visitors,
                                <Employee>[],
                              ),
                            );
                          } else {
                            bloc.add(
                              PassRequestFieldChanged(
                                PassRequestField.visitors,
                                <String>[],
                              ),
                            );
                          }
                          // Сбросить поля purpose и otherPurpose
                          if (v == PassType.overtime ||
                              v == PassType.contractor) {
                            bloc.add(
                              PassRequestFieldChanged(
                                PassRequestField.purpose,
                                null,
                              ),
                            );
                            bloc.add(
                              PassRequestFieldChanged(
                                PassRequestField.otherPurpose,
                                '',
                              ),
                            );
                          } else {
                            bloc.add(
                              PassRequestFieldChanged(
                                PassRequestField.purpose,
                                null,
                              ),
                            );
                            bloc.add(
                              PassRequestFieldChanged(
                                PassRequestField.otherPurpose,
                                null,
                              ),
                            );
                          }
                        },
                        errorText: errors[PassRequestField.type],
                      ),
                      const Gap(16),
                      AppModalSelector<Organization>(
                        title: 'Юридическое лицо',
                        items: organizations,
                        selected: fields[PassRequestField.legalEntity],
                        itemLabel: (o) => o.name,
                        onSelected:
                            (v) => bloc.add(
                              PassRequestFieldChanged(
                                PassRequestField.legalEntity,
                                v,
                              ),
                            ),
                        errorText: errors[PassRequestField.legalEntity],
                      ),
                      const Gap(16),
                      AppModalSelector<Office>(
                        title: 'Офис',
                        items: offices,
                        selected: fields[PassRequestField.office],
                        itemLabel: (o) => o.name,
                        onSelected: (v) {
                          bloc.add(
                            PassRequestFieldChanged(PassRequestField.office, v),
                          );
                          bloc.add(
                            PassRequestFieldBlurred(PassRequestField.office),
                          );
                        },
                        errorText: errors[PassRequestField.office],
                      ),
                      const Gap(16),
                      AppModalSelector<int>(
                        title: 'Этаж',
                        items:
                            fields[PassRequestField.office] != null
                                ? (fields[PassRequestField.office] as Office)
                                    .floors
                                : (() {
                                  final set = {
                                    for (final o in offices) ...o.floors,
                                  };
                                  final list = List<int>.from(set);
                                  list.sort();
                                  return list;
                                })(),
                        selected: fields[PassRequestField.floor],
                        itemLabel: (f) => f.toString(),
                        onSelected: (v) {
                          bloc.add(
                            PassRequestFieldChanged(PassRequestField.floor, v),
                          );
                          final matchingOffice = offices.firstWhere(
                            (o) => o.floors.contains(v),
                            orElse: () => fields[PassRequestField.office],
                          );
                          if (matchingOffice !=
                              fields[PassRequestField.office]) {
                            bloc.add(
                              PassRequestFieldChanged(
                                PassRequestField.office,
                                matchingOffice,
                              ),
                            );
                          }
                          bloc.add(
                            PassRequestFieldBlurred(PassRequestField.floor),
                          );
                        },
                        errorText: errors[PassRequestField.floor],
                      ),
                      const Gap(8),
                      const SectionLabel(
                        'ОКО - 42,43; ГС Москва - 7; ГС СПб - 10; Авилон - 1, 2, 4, 6, 8, 10, 12, 17',
                      ),

                      const Gap(16),
                      if (isOtherPurpose) ...[
                        AppTextArea(
                          hint: 'Цель посещения',
                          controller:
                              _purposeController
                                ..text =
                                    fields[PassRequestField.otherPurpose] ?? '',
                          onChanged:
                              (v) => bloc.add(
                                PassRequestFieldChanged(
                                  PassRequestField.otherPurpose,
                                  v,
                                ),
                              ),
                          errorText: purposeError,
                        ),
                        const Gap(16),
                      ] else ...[
                        AppModalSelector<PassPurpose>(
                          title: 'Цель посещения',
                          items: purposes,
                          selected: fields[PassRequestField.purpose],
                          itemLabel: passPurposeLabel,
                          onSelected: (v) {
                            bloc.add(
                              PassRequestFieldChanged(
                                PassRequestField.purpose,
                                v,
                              ),
                            );
                            bloc.add(
                              PassRequestFieldBlurred(PassRequestField.purpose),
                            );
                          },
                          errorText: purposeError,
                        ),
                        if (fields[PassRequestField.purpose] ==
                            PassPurpose.other)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: AppTextField(
                              hint: 'Укажите цель',
                              onChanged:
                                  (v) => bloc.add(
                                    PassRequestFieldChanged(
                                      PassRequestField.otherPurpose,
                                      v,
                                    ),
                                  ),
                              errorText: errors[PassRequestField.otherPurpose],
                              focusNode:
                                  controllers.focusNodes[PassRequestField
                                      .otherPurpose],
                            ),
                          ),
                        const Gap(16),
                      ],
                      if (fields[PassRequestField.type] !=
                          PassType.permanent) ...[
                        AppDatePickerField(
                          mode: AppDatePickerMode.range,
                          hint: 'Дата или период',
                          rangeValue: fields[PassRequestField.date],
                          onRangeChanged:
                              (v) => bloc.add(
                                PassRequestFieldChanged(
                                  PassRequestField.date,
                                  v,
                                ),
                              ),
                          errorText: errors[PassRequestField.date],
                        ),
                        const Gap(16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppTimePickerField(
                                hint: 'Часы «C»',
                                value: fields[PassRequestField.timeFrom],
                                onChanged:
                                    (v) => bloc.add(
                                      PassRequestFieldChanged(
                                        PassRequestField.timeFrom,
                                        v,
                                      ),
                                    ),
                                errorText: errors[PassRequestField.timeFrom],
                                focusNode:
                                    controllers.focusNodes[PassRequestField
                                        .timeFrom],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppTimePickerField(
                                hint: 'Часы «До»',
                                value: fields[PassRequestField.timeTo],
                                onChanged:
                                    (v) => bloc.add(
                                      PassRequestFieldChanged(
                                        PassRequestField.timeTo,
                                        v,
                                      ),
                                    ),
                                errorText: errors[PassRequestField.timeTo],
                                focusNode:
                                    controllers.focusNodes[PassRequestField
                                        .timeTo],
                              ),
                            ),
                          ],
                        ),
                        const Gap(24),
                      ],
                      if (fields[PassRequestField.type] == PassType.overtime ||
                          fields[PassRequestField.type] ==
                              PassType.contractor) ...[
                        AppModalSelector<EntryPoint>(
                          title: 'Вход через',
                          items: EntryPoint.values,
                          selected: fields[PassRequestField.entryPoint],
                          itemLabel: (e) => e.label,
                          onSelected:
                              (v) => bloc.add(
                                PassRequestFieldChanged(
                                  PassRequestField.entryPoint,
                                  v,
                                ),
                              ),
                          errorText: errors[PassRequestField.entryPoint],
                        ),
                        const Gap(16),
                        if (fields[PassRequestField.type] ==
                            PassType.contractor) ...[
                          AppTextArea(
                            hint: 'Помещения проведения работ',
                            controller: _workRoomsController,
                            onChanged:
                                (v) => bloc.add(
                                  PassRequestFieldChanged(
                                    PassRequestField.workRooms,
                                    v,
                                  ),
                                ),
                            errorText: errors[PassRequestField.workRooms],
                          ),
                          const Gap(16),
                          AppTextArea(
                            hint: 'Список оборудования',
                            controller: _equipmentListController,
                            onChanged:
                                (v) => bloc.add(
                                  PassRequestFieldChanged(
                                    PassRequestField.equipmentList,
                                    v,
                                  ),
                                ),
                            errorText: errors[PassRequestField.equipmentList],
                          ),
                          const Gap(16),
                        ],
                      ],
                      (fields[PassRequestField.type] == PassType.permanent)
                          ? BlocBuilder<EmployeesBloc, EmployeesState>(
                            builder: (context, empState) {
                              if (empState is EmployeesLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (empState is EmployeesError) {
                                return Text(
                                  'Ошибка загрузки сотрудников: ${empState.message}',
                                );
                              } else if (empState is EmployeesLoaded) {
                                return Column(
                                  children: [
                                    EmployeeListSelector<Employee>(
                                      title: 'Посетители',
                                      addButtonText: 'Добавить сотрудника',
                                      allEmployees: empState.employees,
                                      selectedEmployees:
                                          (fields[PassRequestField.visitors]
                                                  as List?)
                                              ?.cast<Employee>() ??
                                          [],
                                      itemLabel: (e) => e.fullName,
                                      onAdd: (e) {
                                        final list = List<Employee>.from(
                                          (fields[PassRequestField.visitors]
                                                  as List?) ??
                                              [],
                                        );
                                        if (list.isEmpty) {
                                          list.add(e);
                                          bloc.add(
                                            PassRequestFieldChanged(
                                              PassRequestField.visitors,
                                              list,
                                            ),
                                          );
                                          bloc.add(
                                            PassRequestFieldBlurred(
                                              PassRequestField.visitors,
                                            ),
                                          );
                                        }
                                      },
                                      onRemove: (e) {
                                        final list = List<Employee>.from(
                                          (fields[PassRequestField.visitors]
                                                  as List?) ??
                                              [],
                                        );
                                        list.remove(e);
                                        bloc.add(
                                          PassRequestFieldChanged(
                                            PassRequestField.visitors,
                                            list,
                                          ),
                                        );
                                        bloc.add(
                                          PassRequestFieldBlurred(
                                            PassRequestField.visitors,
                                          ),
                                        );
                                      },
                                      errorText:
                                          errors[PassRequestField.visitors],
                                      maxCount: 1,
                                    ),
                                    const Gap(16),
                                    AppDatePickerField(
                                      hint: 'Дата выхода',
                                      value:
                                          fields[PassRequestField.dateOfStart],
                                      onChanged:
                                          (v) => bloc.add(
                                            PassRequestFieldChanged(
                                              PassRequestField.dateOfStart,
                                              v,
                                            ),
                                          ),
                                      errorText:
                                          errors[PassRequestField.dateOfStart],
                                      mode: AppDatePickerMode.single,
                                    ),
                                    const Gap(16),
                                    AppFileGrid(
                                      title: 'Фото',
                                      files:
                                          fields[PassRequestField.photo] !=
                                                      null &&
                                                  fields[PassRequestField
                                                          .photo] !=
                                                      ''
                                              ? [
                                                AppFileGridItem(
                                                  name: 'Фото',
                                                  extension: 'jpg',
                                                  sizeBytes: 1,
                                                ),
                                              ]
                                              : [],
                                      addButtonText: 'Добавить фото',
                                      onAddFile: () {
                                        bloc.add(
                                          PassRequestFieldChanged(
                                            PassRequestField.photo,
                                            'mock_photo.jpg',
                                          ),
                                        );
                                        bloc.add(
                                          PassRequestFieldBlurred(
                                            PassRequestField.photo,
                                          ),
                                        );
                                      },
                                      onRemoveFile: (name) {
                                        bloc.add(
                                          PassRequestFieldChanged(
                                            PassRequestField.photo,
                                            null,
                                          ),
                                        );
                                        bloc.add(
                                          PassRequestFieldBlurred(
                                            PassRequestField.photo,
                                          ),
                                        );
                                      },
                                    ),
                                    if (errors[PassRequestField.photo] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 4,
                                        ),
                                        child: Text(
                                          errors[PassRequestField.photo]!,
                                          style: AppTypography.text2Regular
                                              .copyWith(
                                                color: AppColors.red500,
                                              ),
                                        ),
                                      ),
                                    const Gap(16),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          )
                          : ManualEmployeeListSelector(
                            title: 'Посетители',
                            addButtonText: 'Добавить посетителя',
                            values:
                                (fields[PassRequestField.visitors] as List?)
                                    ?.cast<String>() ??
                                const <String>[],
                            onChanged: (list) {
                              bloc.add(
                                PassRequestFieldChanged(
                                  PassRequestField.visitors,
                                  list,
                                ),
                              );
                              bloc.add(
                                PassRequestFieldBlurred(
                                  PassRequestField.visitors,
                                ),
                              );
                            },
                            errorText: errors[PassRequestField.visitors],
                            maxCount: 5,
                          ),
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
                  child: SubmitButtonSection<PassRequestBloc, PassRequestState>(
                    formKey: _formKey,
                    onSubmit: (context) {
                      FocusScope.of(context).unfocus();
                      context.read<PassRequestBloc>().add(
                        PassRequestSubmitted(),
                      );
                    },
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
    );
  }
}
