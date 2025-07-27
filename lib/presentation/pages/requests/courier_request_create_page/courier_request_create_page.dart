import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/presentation/pages/requests/courier_request_create_page/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/presentation/blocs/courier_request/courier_request_bloc.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_fields_list.dart';
import 'package:hr_tcc/domain/repositories/courier_request_repository_mock.dart';

class CourierRequestCreatePage extends StatelessWidget {
  const CourierRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => CourierRequestBloc(
            FetchCourierRequestDataUseCase(CourierRequestRepositoryMock()),
          )..add(CourierRequestLoadData()),
      child: const _CourierRequestCreateView(),
    );
  }
}

class _CourierRequestCreateView extends StatefulWidget {
  const _CourierRequestCreateView();

  @override
  State<_CourierRequestCreateView> createState() =>
      _CourierRequestCreateViewState();
}

class _CourierRequestCreateViewState extends State<_CourierRequestCreateView> {
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _fioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _expReasonController = TextEditingController();
  final TextEditingController _contentDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Map<CourierRequestField, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    for (final key in allCourierRequestFields) {
      _focusNodes[key] = FocusNode();
      _focusNodes[key]!.addListener(() {
        if (!_focusNodes[key]!.hasFocus) {
          final controller = _getControllerByKey(key);
          if (controller != null && mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.read<CourierRequestBloc>().add(
                  CourierRequestFieldBlurred(key),
                );
              }
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.read<CourierRequestBloc>().add(
                  CourierRequestFieldBlurred(key),
                );
              }
            });
          }
        }
      });
    }
  }

  TextEditingController? _getControllerByKey(CourierRequestField key) {
    switch (key) {
      case CourierRequestField.company:
        return _companyController;
      case CourierRequestField.department:
        return _departmentController;
      case CourierRequestField.contactPhone:
        return _contactPhoneController;
      case CourierRequestField.companyName:
        return _companyNameController;
      case CourierRequestField.address:
        return _addressController;
      case CourierRequestField.fio:
        return _fioController;
      case CourierRequestField.phone:
        return _phoneController;
      case CourierRequestField.email:
        return _emailController;
      case CourierRequestField.expReason:
        return _expReasonController;
      case CourierRequestField.contentDesc:
        return _contentDescController;
      case CourierRequestField.comment:
        return _commentController;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    _priorityController.dispose();
    _commentController.dispose();
    _companyController.dispose();
    _departmentController.dispose();
    _contactPhoneController.dispose();
    _companyNameController.dispose();
    _addressController.dispose();
    _fioController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _expReasonController.dispose();
    _contentDescController.dispose();
    super.dispose();
  }

  void _syncControllers(CourierRequestState state) {
    void sync(TextEditingController c, String? v) {
      if (c.text != (v ?? '')) {
        c.text = v ?? '';
        c.selection = TextSelection.fromPosition(
          TextPosition(offset: c.text.length),
        );
      }
    }

    sync(_priorityController, state.fields[CourierRequestField.priority]);
    sync(_commentController, state.fields[CourierRequestField.comment]);
    sync(_companyController, state.fields[CourierRequestField.company]);
    sync(_departmentController, state.fields[CourierRequestField.department]);
    sync(
      _contactPhoneController,
      state.fields[CourierRequestField.contactPhone],
    );
    sync(_companyNameController, state.fields[CourierRequestField.companyName]);
    sync(_addressController, state.fields[CourierRequestField.address]);
    sync(_fioController, state.fields[CourierRequestField.fio]);
    sync(_phoneController, state.fields[CourierRequestField.phone]);
    sync(_emailController, state.fields[CourierRequestField.email]);
    sync(_expReasonController, state.fields[CourierRequestField.expReason]);
    sync(_contentDescController, state.fields[CourierRequestField.contentDesc]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourierRequestBloc, CourierRequestState>(
      listenWhen:
          (prev, curr) =>
              prev.fields != curr.fields || prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        _syncControllers(state);
        if (state.isSuccess && context.mounted) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<CourierRequestBloc, CourierRequestState>(
        builder: (context, state) {
          _syncControllers(state);
          final isRegions = state.deliveryType == CourierDeliveryType.regions;
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.white,
                appBar: const RequestCreationAppBar(title: 'Создание заявки'),
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Курьерская доставка',
                              style: AppTypography.title2Bold,
                            ),

                            const Gap(16),
                            const DeliveryTypeSwitcher(),
                            if (isRegions) ...[
                              const Gap(16),
                              AppHintCard(
                                type: AppHintCardType.success,
                                arrowPosition:
                                    AppHintCardArrowPosition.topRight,
                                arrowOffset: 32,
                                content: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'Если заказ возможно исполнить посредством Почты РФ, передайте отправление в отдел документационного обеспечения, приложите почтовый адрес. ',
                                          style: AppTypography.text2Regular
                                              .copyWith(color: AppColors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              'В данном случае заполнение заявки не требуется.',
                                          style: AppTypography.text2Semibold
                                              .copyWith(color: AppColors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(28),
                              AppTextArea(
                                hint:
                                    'Обоснование выбора услуг экспресс-доставки',
                                controller: _expReasonController,
                                focusNode:
                                    _focusNodes[CourierRequestField.expReason],
                                onChanged:
                                    (v) =>
                                        context.read<CourierRequestBloc>().add(
                                          CourierRequestFieldChanged(
                                            CourierRequestField.expReason,
                                            v,
                                          ),
                                        ),
                                errorText:
                                    state.errors[CourierRequestField.expReason],
                              ),
                              const Gap(8),
                              AppTextArea(
                                hint: 'Опись содержимого',
                                controller: _contentDescController,
                                focusNode:
                                    _focusNodes[CourierRequestField
                                        .contentDesc],
                                onChanged:
                                    (v) =>
                                        context.read<CourierRequestBloc>().add(
                                          CourierRequestFieldChanged(
                                            CourierRequestField.contentDesc,
                                            v,
                                          ),
                                        ),
                                errorText:
                                    state.errors[CourierRequestField
                                        .contentDesc],
                              ),
                              const Gap(8),
                            ],
                            const Gap(24),
                            SenderSection(
                              companyController: _companyController,
                              departmentController: _departmentController,
                              contactPhoneController: _contactPhoneController,
                              focusNodes: _focusNodes,
                              errors: state.errors,
                            ),
                            const Gap(24),
                            DeliveryDatesSection(
                              priorityController: _priorityController,
                              focusNodes: _focusNodes,
                              errors: state.errors,
                            ),
                            const Gap(24),
                            ReceiverSection(
                              companyNameController: _companyNameController,
                              addressController: _addressController,
                              fioController: _fioController,
                              phoneController: _phoneController,
                              emailController: _emailController,
                              focusNodes: _focusNodes,
                              errors: state.errors,
                            ),
                            const Gap(24),
                            CommentSection<
                              CourierRequestBloc,
                              CourierRequestState
                            >(
                              commentController: _commentController,
                              addCommentFieldKey:
                                  CourierRequestField.addComment,
                              commentFieldKey: CourierRequestField.comment,
                              switchLabel: 'Добавить комментарий',
                              focusNode:
                                  _focusNodes[CourierRequestField.comment],
                              errors: state.errors,
                              onFieldChanged:
                                  (field, value) =>
                                      context.read<CourierRequestBloc>().add(
                                        CourierRequestFieldChanged(
                                          field,
                                          value,
                                        ),
                                      ),
                              addCommentSelector:
                                  (s, key) => (s.fields[key] as bool?) ?? false,
                              commentSelector:
                                  (s, key) => (s.fields[key] as String?) ?? '',
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
                      CourierRequestBloc,
                      CourierRequestState
                    >(
                      formKey: _formKey,
                      onSubmit: (context) {
                        FocusScope.of(context).unfocus();
                        context.read<CourierRequestBloc>().add(
                          CourierRequestSubmit(),
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
