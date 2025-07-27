import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/themes/themes.dart';
import '../../../../domain/entities/entities.dart';
import '../../../blocs/blocs.dart';
import '../../../widgets/common/common.dart';
import '../components/components.dart';
import 'components/parking_request_controllers.dart';

class ParkingRequestCreatePage extends StatelessWidget {
  const ParkingRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocFactory.createParkingRequestBloc(),
      child: const _ParkingRequestForm(),
    );
  }
}

class _ParkingRequestForm extends StatefulWidget {
  const _ParkingRequestForm();

  @override
  State<_ParkingRequestForm> createState() => _ParkingRequestFormState();
}

class _ParkingRequestFormState extends State<_ParkingRequestForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _carNumberController;
  late final ParkingRequestControllers controllers;
  // Вместо этого используем offices из request_dropdowns.dart

  @override
  void initState() {
    super.initState();
    _carNumberController = TextEditingController();
    controllers = ParkingRequestControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllers.addBlurListeners(context);
      context.read<ParkingRequestBloc>().add(ParkingRequestLoadCarBrands());
    });
  }

  @override
  void dispose() {
    _carNumberController.dispose();
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingRequestBloc, ParkingRequestState>(
      builder: (context, state) {
        return BlocListener<ParkingRequestBloc, ParkingRequestState>(
          listenWhen: (prev, curr) => prev.success != curr.success,
          listener: (context, state) {
            if (state.success && context.mounted) {
              FocusScope.of(context).unfocus();
              context.pop(true);
            }
          },
          child: _ParkingRequestFormBody(
            state: state,
            bloc: context.read<ParkingRequestBloc>(),
            controllers: controllers,
            formKey: _formKey,
          ),
        );
      },
    );
  }
}

class _ParkingRequestFormBody extends StatelessWidget {
  final ParkingRequestState state;
  final ParkingRequestBloc bloc;
  final ParkingRequestControllers controllers;
  final GlobalKey<FormState> formKey;
  const _ParkingRequestFormBody({
    required this.state,
    required this.bloc,
    required this.controllers,
    required this.formKey,
  });

  bool _showError(ParkingRequestField field) {
    return (state.submitted || state.errors.containsKey(field));
  }

  @override
  Widget build(BuildContext context) {
    final fields = state.fields;
    final errors = state.errors;
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
                  Text('Парковка', style: AppTypography.title2Bold),
                  const SizedBox(height: 24),
                  // Заменяю AppRadioSwitcher на AppModalSelector
                  AppModalSelector<ParkingType>(
                    title: 'Тип парковки',
                    items: const [
                      ParkingType.guest,
                      ParkingType.cargo,
                      ParkingType.reserved,
                    ],
                    selected: fields[ParkingRequestField.type],
                    itemLabel: (type) {
                      switch (type) {
                        case ParkingType.guest:
                          return 'Гостевой паркинг';
                        case ParkingType.cargo:
                          return 'Грузовой паркинг';
                        case ParkingType.reserved:
                          return 'Паркинг на определенное место';
                      }
                    },
                    onSelected: (v) {
                      bloc.add(
                        ParkingRequestFieldChanged(ParkingRequestField.type, v),
                      );
                      bloc.add(
                        ParkingRequestFieldBlurred(ParkingRequestField.type),
                      );
                    },
                    errorText:
                        _showError(ParkingRequestField.type)
                            ? errors[ParkingRequestField.type]
                            : null,
                  ),
                  const SizedBox(height: 16),
                  // Для "Гостевой" и "Грузовой" паркинг добавляем поле "Цель посещения"
                  if (fields[ParkingRequestField.type] == ParkingType.guest ||
                      fields[ParkingRequestField.type] == ParkingType.cargo)
                    AppTextArea(
                      hint: 'Цель посещения',
                      controller:
                          controllers.textControllers[ParkingRequestField
                              .purposeText],
                      focusNode:
                          controllers.focusNodes[ParkingRequestField
                              .purposeText],
                      onChanged:
                          (v) => bloc.add(
                            ParkingRequestFieldChanged(
                              ParkingRequestField.purposeText,
                              v,
                            ),
                          ),
                      errorText: errors[ParkingRequestField.purposeText],
                    ),
                  const SizedBox(height: 16),
                  AppModalSelector<Office>(
                    title: 'Офис',
                    items: offices,
                    selected: fields[ParkingRequestField.office],
                    itemLabel: (o) => o.name,
                    onSelected: (v) {
                      bloc.add(
                        ParkingRequestFieldChanged(
                          ParkingRequestField.office,
                          v,
                        ),
                      );
                      bloc.add(
                        ParkingRequestFieldBlurred(ParkingRequestField.office),
                      );
                    },
                    errorText:
                        _showError(ParkingRequestField.office)
                            ? errors[ParkingRequestField.office]
                            : null,
                  ),
                  const SizedBox(height: 16),
                  AppModalSelector<int>(
                    title: 'Этаж',
                    items:
                        fields[ParkingRequestField.office] != null
                            ? (fields[ParkingRequestField.office] as Office)
                                .floors
                            : (() {
                              final set = {
                                for (final o in offices) ...o.floors,
                              };
                              final list = List<int>.from(set);
                              list.sort();
                              return list;
                            })(),
                    selected: fields[ParkingRequestField.floor],
                    itemLabel: (f) => f.toString(),
                    onSelected: (v) {
                      bloc.add(
                        ParkingRequestFieldChanged(
                          ParkingRequestField.floor,
                          v,
                        ),
                      );
                      final matchingOffice = offices.firstWhere(
                        (o) => o.floors.contains(v),
                        orElse: () => fields[ParkingRequestField.office],
                      );
                      if (matchingOffice !=
                          fields[ParkingRequestField.office]) {
                        bloc.add(
                          ParkingRequestFieldChanged(
                            ParkingRequestField.office,
                            matchingOffice,
                          ),
                        );
                      }
                      bloc.add(
                        ParkingRequestFieldBlurred(ParkingRequestField.floor),
                      );
                    },
                    errorText:
                        _showError(ParkingRequestField.floor)
                            ? errors[ParkingRequestField.floor]
                            : null,
                  ),
                  const SizedBox(height: 16),
                  // Период заезда/выезда
                  AppDatePickerField(
                    mode: AppDatePickerMode.range,
                    hint: 'Период заезда/выезда',
                    rangeValue: fields[ParkingRequestField.date],
                    onRangeChanged:
                        (v) => bloc.add(
                          ParkingRequestFieldChanged(
                            ParkingRequestField.date,
                            v,
                          ),
                        ),
                    errorText: errors[ParkingRequestField.date],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTimePickerField(
                          hint: 'Часы «C»',
                          value: fields[ParkingRequestField.timeFrom],
                          onChanged:
                              (v) => bloc.add(
                                ParkingRequestFieldChanged(
                                  ParkingRequestField.timeFrom,
                                  v,
                                ),
                              ),
                          errorText: errors[ParkingRequestField.timeFrom],
                          focusNode:
                              controllers.focusNodes[ParkingRequestField
                                  .timeFrom],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTimePickerField(
                          hint: 'Часы «До»',
                          value: fields[ParkingRequestField.timeTo],
                          onChanged:
                              (v) => bloc.add(
                                ParkingRequestFieldChanged(
                                  ParkingRequestField.timeTo,
                                  v,
                                ),
                              ),
                          errorText: errors[ParkingRequestField.timeTo],
                          focusNode:
                              controllers.focusNodes[ParkingRequestField
                                  .timeTo],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Заявки принимаются с 09:00 до 20:45, подавать заранее за 2 ч.',
                    style: AppTypography.text2Regular.copyWith(
                      color: AppColors.gray700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Марка автомобиля
                  if (state.carBrandsLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.carBrandsError != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Ошибка загрузки марок: ${state.carBrandsError}',
                        style: AppTypography.text2Regular.copyWith(
                          color: AppColors.red500,
                        ),
                      ),
                    )
                  else
                    AppModalSelector<String>(
                      title: 'Марка автомобиля',
                      items: state.carBrands,
                      selected: fields[ParkingRequestField.carBrand],
                      itemLabel: (b) => b,
                      onSelected: (v) {
                        bloc.add(
                          ParkingRequestFieldChanged(
                            ParkingRequestField.carBrand,
                            v,
                          ),
                        );
                        bloc.add(
                          ParkingRequestFieldBlurred(
                            ParkingRequestField.carBrand,
                          ),
                        );
                      },
                      errorText:
                          _showError(ParkingRequestField.carBrand)
                              ? errors[ParkingRequestField.carBrand]
                              : null,
                    ),
                  const SizedBox(height: 16),
                  AppTextField(
                    hint: 'Госномер автомобиля',
                    controller:
                        controllers.textControllers[ParkingRequestField
                            .carNumber],
                    focusNode:
                        controllers.focusNodes[ParkingRequestField.carNumber],
                    onChanged:
                        (v) => bloc.add(
                          ParkingRequestFieldChanged(
                            ParkingRequestField.carNumber,
                            v,
                          ),
                        ),
                    errorText:
                        _showError(ParkingRequestField.carNumber)
                            ? errors[ParkingRequestField.carNumber]
                            : null,
                  ),
                  const SizedBox(height: 16),
                  // Для "Паркинг на определенное место" добавляем поле "Номер парковочного места"
                  if (fields[ParkingRequestField.type] == ParkingType.reserved)
                    AppTextField(
                      hint: 'Номер парковочного места',
                      onChanged:
                          (v) => bloc.add(
                            ParkingRequestFieldChanged(
                              ParkingRequestField.parkingPlaceNumber,
                              v,
                            ),
                          ),
                      errorText: errors[ParkingRequestField.parkingPlaceNumber],
                    ),
                  const SizedBox(height: 16),
                  // Для "Грузовой" паркинг добавляем дополнительные поля
                  if (fields[ParkingRequestField.type] ==
                      ParkingType.cargo) ...[
                    AppTextArea(
                      hint: 'Основание',
                      controller:
                          controllers.textControllers[ParkingRequestField
                              .cargoReason],
                      onChanged:
                          (v) => bloc.add(
                            ParkingRequestFieldChanged(
                              ParkingRequestField.cargoReason,
                              v,
                            ),
                          ),
                      errorText: errors[ParkingRequestField.cargoReason],
                    ),
                    const SizedBox(height: 16),
                    AppTextArea(
                      hint: 'Описание груза',
                      controller:
                          controllers.textControllers[ParkingRequestField
                              .cargoDescription],
                      onChanged:
                          (v) => bloc.add(
                            ParkingRequestFieldChanged(
                              ParkingRequestField.cargoDescription,
                              v,
                            ),
                          ),
                      errorText: errors[ParkingRequestField.cargoDescription],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      hint: 'Водитель',
                      controller:
                          controllers.textControllers[ParkingRequestField
                              .driver],
                      onChanged:
                          (v) => bloc.add(
                            ParkingRequestFieldChanged(
                              ParkingRequestField.driver,
                              v,
                            ),
                          ),
                      errorText: errors[ParkingRequestField.driver],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      hint: 'Сопровождающий',
                      controller:
                          controllers.textControllers[ParkingRequestField
                              .escort],
                      onChanged:
                          (v) => bloc.add(
                            ParkingRequestFieldChanged(
                              ParkingRequestField.escort,
                              v,
                            ),
                          ),
                      errorText: errors[ParkingRequestField.escort],
                    ),
                    const SizedBox(height: 16),
                    AppModalSelector<String>(
                      title: 'Действие лифта',
                      items: const [
                        'Подъем',
                        'Подъем - спуск',
                        'Спуск',
                        'Спуск - подъем',
                      ],
                      selected: fields[ParkingRequestField.liftAction],
                      itemLabel: (v) => v,
                      onSelected:
                          (v) => bloc.add(
                            ParkingRequestFieldChanged(
                              ParkingRequestField.liftAction,
                              v,
                            ),
                          ),
                      errorText: errors[ParkingRequestField.liftAction],
                    ),
                    const SizedBox(height: 16),
                    AppModalSelector<int>(
                      title: 'Номер лифта',
                      items: const [1, 6, 21],
                      selected: fields[ParkingRequestField.liftNumber],
                      itemLabel: (v) => v.toString(),
                      onSelected:
                          (v) => bloc.add(
                            ParkingRequestFieldChanged(
                              ParkingRequestField.liftNumber,
                              v,
                            ),
                          ),
                      errorText: errors[ParkingRequestField.liftNumber],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ГС Москва - 6, ГС СПб - 21, ОКО - 1',
                      style: AppTypography.text2Regular.copyWith(
                        color: AppColors.gray700,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 16),
                  // Показываем поле "ФИО посетителя(ей)" только для нужных типов парковки
                  if (fields[ParkingRequestField.type] == ParkingType.guest ||
                      fields[ParkingRequestField.type] == ParkingType.reserved)
                    ManualEmployeeListSelector(
                      title: 'ФИО посетителя(ей)',
                      addButtonText: 'Добавить посетителя',
                      values: List<String>.from(
                        fields[ParkingRequestField.visitors] ?? [],
                      ),
                      onChanged: (updated) {
                        bloc.add(
                          ParkingRequestFieldChanged(
                            ParkingRequestField.visitors,
                            updated,
                          ),
                        );
                        bloc.add(
                          ParkingRequestFieldBlurred(
                            ParkingRequestField.visitors,
                          ),
                        );
                      },
                      errorText:
                          _showError(ParkingRequestField.visitors)
                              ? errors[ParkingRequestField.visitors]
                              : null,
                    ),
                  const SizedBox(height: 32),
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
                  ParkingRequestBloc,
                  ParkingRequestState
                >(
                  formKey: formKey,
                  onSubmit: (context) {
                    FocusScope.of(context).unfocus();
                    context.read<ParkingRequestBloc>().add(
                      ParkingRequestSubmitted(),
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
  }
}
