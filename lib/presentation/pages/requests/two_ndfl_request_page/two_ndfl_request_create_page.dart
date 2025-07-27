import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class TwoNdflRequestCreatePage extends StatelessWidget {
  const TwoNdflRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocFactory.createTwoNdflRequestBloc(),
      child: const _TwoNdflRequestCreateView(),
    );
  }
}

class _TwoNdflRequestCreateView extends StatefulWidget {
  const _TwoNdflRequestCreateView();
  @override
  State<_TwoNdflRequestCreateView> createState() =>
      _TwoNdflRequestCreateViewState();
}

class _TwoNdflRequestCreateViewState extends State<_TwoNdflRequestCreateView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TwoNdflRequestBloc, TwoNdflRequestState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<TwoNdflRequestBloc, TwoNdflRequestState>(
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
                              'Справка 2-НДФЛ',
                              style: AppTypography.title2Bold.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            const Gap(24),
                            _PurposeDropdown(),
                            const Gap(16),
                            _PeriodPicker(),
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
                      TwoNdflRequestBloc,
                      TwoNdflRequestState
                    >(
                      formKey: _formKey,
                      onSubmit: (context) {
                        FocusScope.of(context).unfocus();
                        context.read<TwoNdflRequestBloc>().add(
                          TwoNdflRequestSubmit(),
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
    return BlocBuilder<TwoNdflRequestBloc, TwoNdflRequestState>(
      builder: (context, state) {
        final error = state.errors[TwoNdflRequestField.purpose];
        final value =
            state.fields[TwoNdflRequestField.purpose] as TwoNdflPurpose?;
        return AppModalSelector<TwoNdflPurpose>(
          title: 'Цель справки',
          items: TwoNdflPurpose.values,
          selected: value,
          itemLabel: (purpose) => purpose.label,
          onSelected: (purpose) {
            context.read<TwoNdflRequestBloc>().add(
              TwoNdflRequestFieldChanged(TwoNdflRequestField.purpose, purpose),
            );
            context.read<TwoNdflRequestBloc>().add(
              const TwoNdflRequestFieldBlurred(TwoNdflRequestField.purpose),
            );
          },
          errorText: error,
        );
      },
    );
  }
}

class _PeriodPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwoNdflRequestBloc, TwoNdflRequestState>(
      builder: (context, state) {
        final error = state.errors[TwoNdflRequestField.period];
        final value =
            state.fields[TwoNdflRequestField.period] as DateTimeRange?;
        return AppDatePickerField(
          hint: 'Период',
          lastDate: DateTime.now(),
          rangeValue: value,
          mode: AppDatePickerMode.range,
          showPastDates: true,
          errorText: error,
          onRangeChanged: (picked) {
            context.read<TwoNdflRequestBloc>().add(
              TwoNdflRequestFieldChanged(TwoNdflRequestField.period, picked),
            );
            context.read<TwoNdflRequestBloc>().add(
              const TwoNdflRequestFieldBlurred(TwoNdflRequestField.period),
            );
          },
        );
      },
    );
  }
}
