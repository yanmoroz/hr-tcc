import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/presentation/blocs/alpina_digital_access_request/alpina_request_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/models/requests/alpina_digital_access_request_models.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';

class AlpinaRequestCreatePage extends StatelessWidget {
  const AlpinaRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlpinaRequestBloc(),
      child: const _AlpinaRequestCreateView(),
    );
  }
}

class _AlpinaRequestCreateView extends StatefulWidget {
  const _AlpinaRequestCreateView();

  @override
  State<_AlpinaRequestCreateView> createState() =>
      _AlpinaRequestCreateViewState();
}

class _AlpinaRequestCreateViewState extends State<_AlpinaRequestCreateView> {
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _syncCommentController(String? value) {
    if (_commentController.text != (value ?? '')) {
      _commentController.text = value ?? '';
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlpinaRequestBloc, AlpinaRequestState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<AlpinaRequestBloc, AlpinaRequestState>(
        builder: (context, state) {
          final date =
              state.fields[AlpinaDigitalAccessRequestField.date] as DateTime?;
          final wasAccessProvided =
              state.fields[AlpinaDigitalAccessRequestField.wasAccessProvided]
                  as bool?;
          final comment =
              state.fields[AlpinaDigitalAccessRequestField.comment]
                  as String? ??
              '';
          _syncCommentController(comment);
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
                              'Предоставление доступа\nк «Альпина Диджитал»',
                              style: AppTypography.title2Bold,
                            ),
                            const Gap(24),
                            AppDatePickerField(
                              hint: 'Дата',
                              value: date,
                              onChanged:
                                  (d) => context.read<AlpinaRequestBloc>().add(
                                    AlpinaRequestFieldChanged(
                                      AlpinaDigitalAccessRequestField.date,
                                      d,
                                    ),
                                  ),
                              errorText:
                                  state.errors[AlpinaDigitalAccessRequestField
                                      .date],
                            ),
                            const Gap(20),
                            Text(
                              'Был ли ранее вам предоставлен доступ?',
                              style: AppTypography.text1Medium.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            const Gap(16),
                            AppRadioSwitcher<bool>(
                              items: [
                                AppRadioSwitcherItem(value: true, label: 'Да'),
                                AppRadioSwitcherItem(
                                  value: false,
                                  label: 'Нет',
                                ),
                              ],
                              groupValue: wasAccessProvided ?? false,
                              onChanged:
                                  (v) => context.read<AlpinaRequestBloc>().add(
                                    AlpinaRequestFieldChanged(
                                      AlpinaDigitalAccessRequestField
                                          .wasAccessProvided,
                                      v,
                                    ),
                                  ),
                            ),
                            const Gap(20),
                            CommentSection<
                              AlpinaRequestBloc,
                              AlpinaRequestState
                            >(
                              commentController: _commentController,
                              errors: state.errors,
                              addCommentFieldKey:
                                  AlpinaDigitalAccessRequestField.addComment,
                              commentFieldKey:
                                  AlpinaDigitalAccessRequestField.comment,
                              switchLabel: 'Добавить комментарий',
                              onFieldChanged:
                                  (field, value) =>
                                      context.read<AlpinaRequestBloc>().add(
                                        AlpinaRequestFieldChanged(field, value),
                                      ),
                              addCommentSelector:
                                  (s, key) => (s.fields[key] as bool?) ?? false,
                              commentSelector:
                                  (s, key) => (s.fields[key] as String?) ?? '',
                            ),
                            const Gap(20),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                context.read<AlpinaRequestBloc>().add(
                                  AlpinaRequestCheckboxChanged(
                                    value: !state.isChecked,
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: AppCheckBox(
                                      value: state.isChecked,
                                      onChanged:
                                          (v) => context
                                              .read<AlpinaRequestBloc>()
                                              .add(
                                                AlpinaRequestCheckboxChanged(
                                                  value: v,
                                                ),
                                              ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Я ознакомлен(а) с информацией о сроке действия ссылки 24 часа и удалении аккаунта при его неиспользовании более 3 месяцев',
                                        style: AppTypography.text2Regular
                                            .copyWith(color: AppColors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state.errors[AlpinaDigitalAccessRequestField
                                    .checkbox] !=
                                null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  bottom: 8,
                                ),
                                child: Text(
                                  state.errors[AlpinaDigitalAccessRequestField
                                      .checkbox]!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            const Gap(12),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child:
                                  !state.isChecked
                                      ? const AppHintCard(
                                        type: AppHintCardType.success,
                                        arrowPosition:
                                            AppHintCardArrowPosition.topLeft,
                                        content:
                                            'Вам придёт письмо со ссылкой для активации доступа к Alpina Digital — перейдите по ней в течение 24 часов, после она станет недействительной. Аккаунт удаляется, если вы не пользуетесь библиотекой более 3 месяцев.',
                                      )
                                      : const SizedBox.shrink(),
                            ),
                            const Gap(24),
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
                      AlpinaRequestBloc,
                      AlpinaRequestState
                    >(
                      formKey: _formKey,
                      onSubmit: (context) {
                        FocusScope.of(context).unfocus();
                        context.read<AlpinaRequestBloc>().add(
                          AlpinaRequestSubmit(),
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
