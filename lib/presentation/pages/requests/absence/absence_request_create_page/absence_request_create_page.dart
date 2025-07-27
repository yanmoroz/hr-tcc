import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/presentation/blocs/absence_request/absence_request_bloc.dart';
import 'package:hr_tcc/domain/usecases/create_absence_request_usecase.dart';
import 'package:hr_tcc/data/repositories/absence_request_repository_mock.dart';
import 'package:hr_tcc/domain/entities/requests/absence_request.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/presentation/pages/requests/absence/absence_request_create_page/components/components.dart';
import 'package:flutter/cupertino.dart';

class AbsenceRequestCreatePage extends StatelessWidget {
  const AbsenceRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => AbsenceRequestBloc(
            CreateAbsenceRequestUseCase(AbsenceRequestRepositoryMock()),
          ),
      child: const _AbsenceRequestCreateView(),
    );
  }
}

class _AbsenceRequestCreateView extends StatefulWidget {
  const _AbsenceRequestCreateView();

  @override
  State<_AbsenceRequestCreateView> createState() =>
      _AbsenceRequestCreateViewState();
}

class _AbsenceRequestCreateViewState extends State<_AbsenceRequestCreateView> {
  final _formKey = GlobalKey<FormState>();
  late final AbsenceRequestControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = AbsenceRequestControllers();
    void addBlurListener(FocusNode node, AbsenceRequestField field) {
      node.addListener(() {
        if (!node.hasFocus) {
          context.read<AbsenceRequestBloc>().add(
            AbsenceRequestFieldBlurred(field),
          );
        }
      });
    }

    addBlurListener(_controllers.dateFocus, AbsenceRequestField.date);
    addBlurListener(_controllers.periodFocus, AbsenceRequestField.period);
    addBlurListener(_controllers.timeFocus, AbsenceRequestField.time);
    addBlurListener(
      _controllers.timeRangeStartFocus,
      AbsenceRequestField.timeRangeStart,
    );
    addBlurListener(
      _controllers.timeRangeEndFocus,
      AbsenceRequestField.timeRangeEnd,
    );
    addBlurListener(_controllers.reasonFocus, AbsenceRequestField.reason);
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, TimeOfDay? initial) async {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      TimeOfDay? picked = initial ?? const TimeOfDay(hour: 9, minute: 0);
      DateTime tempDateTime = DateTime(
        0,
        0,
        0,
        initial?.hour ?? 9,
        initial?.minute ?? 0,
      );
      final result = await showCupertinoModalPopup<TimeOfDay>(
        context: context,
        builder:
            (_) => Container(
              height: 320,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text('Отменить'),
                          onPressed: () => context.pop(),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text('Готово'),
                          onPressed: () => context.pop(picked),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: tempDateTime,
                          use24hFormat: true,
                          onDateTimeChanged: (dateTime) {
                            picked = TimeOfDay(
                              hour: dateTime.hour,
                              minute: dateTime.minute,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      );
      return result;
    } else {
      return showTimePicker(
        context: context,
        initialTime: initial ?? TimeOfDay.now(),
        builder: (context, child) => child!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AbsenceRequestBloc, AbsenceRequestState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess && context.mounted) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<AbsenceRequestBloc, AbsenceRequestState>(
        builder: (context, state) {
          final type = state.fields[AbsenceRequestField.type] as AbsenceType?;
          final reason =
              state.fields[AbsenceRequestField.reason] as String? ?? '';
          final time = state.fields[AbsenceRequestField.time] as TimeOfDay?;
          final timeRangeStart =
              state.fields[AbsenceRequestField.timeRangeStart] as TimeOfDay?;
          final timeRangeEnd =
              state.fields[AbsenceRequestField.timeRangeEnd] as TimeOfDay?;
          // Синхронизация контроллеров
          if (_controllers.reasonController.text != reason) {
            _controllers.reasonController.text = reason;
            _controllers
                .reasonController
                .selection = TextSelection.fromPosition(
              TextPosition(offset: _controllers.reasonController.text.length),
            );
          }
          final timeText = time != null ? time.format(context) : '';
          if (_controllers.timeController.text != timeText) {
            _controllers.timeController.text = timeText;
            _controllers.timeController.selection = TextSelection.fromPosition(
              TextPosition(offset: _controllers.timeController.text.length),
            );
          }
          final timeRangeStartText =
              timeRangeStart != null ? timeRangeStart.format(context) : '';
          if (_controllers.timeRangeStartController.text !=
              timeRangeStartText) {
            _controllers.timeRangeStartController.text = timeRangeStartText;
            _controllers
                .timeRangeStartController
                .selection = TextSelection.fromPosition(
              TextPosition(
                offset: _controllers.timeRangeStartController.text.length,
              ),
            );
          }
          final timeRangeEndText =
              timeRangeEnd != null ? timeRangeEnd.format(context) : '';
          if (_controllers.timeRangeEndController.text != timeRangeEndText) {
            _controllers.timeRangeEndController.text = timeRangeEndText;
            _controllers
                .timeRangeEndController
                .selection = TextSelection.fromPosition(
              TextPosition(
                offset: _controllers.timeRangeEndController.text.length,
              ),
            );
          }

          return Stack(
            children: [
              Scaffold(
                appBar: const RequestCreationAppBar(title: 'Создание заявки'),
                backgroundColor: AppColors.white,
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Text('Отсутствие', style: AppTypography.title2Bold),
                        const SizedBox(height: 24),
                        AppModalSelector<AbsenceType>(
                          title: 'Тип',
                          items: AbsenceType.values,
                          selected: type ?? AbsenceType.earlyLeave,
                          itemLabel: (type) => type.label,
                          onSelected: (type) {
                            context.read<AbsenceRequestBloc>().add(
                              AbsenceRequestFieldChanged(
                                AbsenceRequestField.type,
                                type,
                              ),
                            );
                          },
                        ),
                        const Gap(16),
                        if (type == AbsenceType.earlyLeave)
                          AbsenceFieldsEarlyLeave(
                            controllers: _controllers,
                            fields: state.fields,
                            errors: state.errors,
                            onChanged:
                                (field, value) =>
                                    context.read<AbsenceRequestBloc>().add(
                                      AbsenceRequestFieldChanged(field, value),
                                    ),
                            onPickTime: _pickTime,
                          )
                        else if (type == AbsenceType.lateArrival)
                          AbsenceFieldsLateArrival(
                            controllers: _controllers,
                            fields: state.fields,
                            errors: state.errors,
                            onChanged:
                                (field, value) =>
                                    context.read<AbsenceRequestBloc>().add(
                                      AbsenceRequestFieldChanged(field, value),
                                    ),
                            onPickTime: _pickTime,
                          )
                        else if (type == AbsenceType.workSchedule)
                          AbsenceFieldsWorkSchedule(
                            controllers: _controllers,
                            fields: state.fields,
                            errors: state.errors,
                            onChanged:
                                (field, value) =>
                                    context.read<AbsenceRequestBloc>().add(
                                      AbsenceRequestFieldChanged(field, value),
                                    ),
                            onPickTime: _pickTime,
                          )
                        else if (type == AbsenceType.other)
                          AbsenceFieldsOther(
                            controllers: _controllers,
                            fields: state.fields,
                            errors: state.errors,
                            onChanged:
                                (field, value) =>
                                    context.read<AbsenceRequestBloc>().add(
                                      AbsenceRequestFieldChanged(field, value),
                                    ),
                            onPickTime: _pickTime,
                          ),
                        if (state.error != null) ...[
                          const Gap(12),
                          Text(
                            state.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
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
                      AbsenceRequestBloc,
                      AbsenceRequestState
                    >(
                      formKey: _formKey,
                      onSubmit: (context) {
                        FocusScope.of(context).unfocus();
                        context.read<AbsenceRequestBloc>().add(
                          AbsenceRequestSubmit(),
                        );
                      },
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
