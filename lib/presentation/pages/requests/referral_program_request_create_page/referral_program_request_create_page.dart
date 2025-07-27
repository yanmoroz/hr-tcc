import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/blocs/referral_program_request/referral_program_request_bloc.dart';
import 'package:hr_tcc/domain/usecases/create_referral_program_request_usecase.dart';
import 'package:hr_tcc/data/repositories/referral_program_request_repository_mock.dart';
import 'package:hr_tcc/domain/entities/requests/referral_program_request.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:file_picker/file_picker.dart';

class ReferralProgramRequestCreatePage extends StatelessWidget {
  const ReferralProgramRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ReferralProgramRequestBloc(
            CreateReferralProgramRequestUseCase(
              ReferralProgramRequestRepositoryMock(),
            ),
            ReferralProgramRequestRepositoryMock(),
          ),
      child: const _ReferralProgramRequestCreateView(),
    );
  }
}

class _ReferralProgramRequestCreateView extends StatefulWidget {
  const _ReferralProgramRequestCreateView();

  @override
  State<_ReferralProgramRequestCreateView> createState() =>
      _ReferralProgramRequestCreateViewState();
}

class _ReferralProgramRequestCreateViewState
    extends State<_ReferralProgramRequestCreateView> {
  final _formKey = GlobalKey<FormState>();
  bool _showComment = false;

  late final TextEditingController _candidateNameController;
  late final TextEditingController _resumeLinkController;
  late final TextEditingController _commentController;
  late final FocusNode _candidateNameFocusNode;
  late final FocusNode _resumeLinkFocusNode;
  late final FocusNode _commentFocusNode;

  @override
  void initState() {
    super.initState();
    _candidateNameController = TextEditingController();
    _resumeLinkController = TextEditingController();
    _commentController = TextEditingController();
    _candidateNameFocusNode = FocusNode();
    _resumeLinkFocusNode = FocusNode();
    _commentFocusNode = FocusNode();

    _candidateNameFocusNode.addListener(() {
      if (!_candidateNameFocusNode.hasFocus) {
        context.read<ReferralProgramRequestBloc>().add(
          ValidateField(
            ReferralProgramRequestField.candidateName,
            _candidateNameController.text,
          ),
        );
      }
    });
    _resumeLinkFocusNode.addListener(() {
      if (!_resumeLinkFocusNode.hasFocus) {
        context.read<ReferralProgramRequestBloc>().add(
          ValidateField(
            ReferralProgramRequestField.resumeLink,
            _resumeLinkController.text,
          ),
        );
      }
    });
    _commentFocusNode.addListener(() {
      if (!_commentFocusNode.hasFocus) {
        context.read<ReferralProgramRequestBloc>().add(
          ValidateField(
            ReferralProgramRequestField.comment,
            _commentController.text,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _candidateNameController.dispose();
    _resumeLinkController.dispose();
    _commentController.dispose();
    _candidateNameFocusNode.dispose();
    _resumeLinkFocusNode.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      ReferralProgramRequestBloc,
      ReferralProgramRequestState
    >(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess && context.mounted) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<
        ReferralProgramRequestBloc,
        ReferralProgramRequestState
      >(
        builder: (context, state) {
          final bloc = context.read<ReferralProgramRequestBloc>();
          final file =
              state.fields[ReferralProgramRequestField.file]
                  as ReferralResumeFile?;
          final files =
              file != null
                  ? [
                    AppFileGridItem(
                      name: file.name,
                      extension: file.extension,
                      sizeBytes: file.size,
                      status: AppFileUploadStatus.success,
                      onRemove:
                          () => bloc.add(
                            const ReferralProgramFieldChanged(
                              ReferralProgramRequestField.file,
                              null,
                            ),
                          ),
                    ),
                  ]
                  : <AppFileGridItem>[];

          // Синхронизируем контроллеры с состоянием
          if (_candidateNameController.text !=
              (state.fields[ReferralProgramRequestField.candidateName] ?? '')) {
            _candidateNameController.text =
                state.fields[ReferralProgramRequestField.candidateName] ?? '';
            _candidateNameController.selection = TextSelection.fromPosition(
              TextPosition(offset: _candidateNameController.text.length),
            );
          }
          if (_resumeLinkController.text !=
              (state.fields[ReferralProgramRequestField.resumeLink] ?? '')) {
            _resumeLinkController.text =
                state.fields[ReferralProgramRequestField.resumeLink] ?? '';
            _resumeLinkController.selection = TextSelection.fromPosition(
              TextPosition(offset: _resumeLinkController.text.length),
            );
          }
          if (_commentController.text !=
              (state.fields[ReferralProgramRequestField.comment] ?? '')) {
            _commentController.text =
                state.fields[ReferralProgramRequestField.comment] ?? '';
            _commentController.selection = TextSelection.fromPosition(
              TextPosition(offset: _commentController.text.length),
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
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: ListView(
                        children: [
                          Text(
                            'Реферальная программа',
                            style: AppTypography.title2Bold,
                          ),
                          const Gap(24),
                          if (state.isVacanciesLoading)
                            const Center(child: CircularProgressIndicator()),
                          if (state.vacanciesError != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Ошибка загрузки вакансий: \\${state.vacanciesError}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          if (!state.isVacanciesLoading &&
                              state.vacancies.isNotEmpty)
                            AppModalSelector<ReferralVacancy>(
                              title: 'Вакансия',
                              items: state.vacancies,
                              selected:
                                  state.fields[ReferralProgramRequestField
                                      .vacancy],
                              itemLabel: (v) => v.label,
                              onSelected:
                                  (v) => bloc.add(
                                    ReferralProgramFieldChanged(
                                      ReferralProgramRequestField.vacancy,
                                      v,
                                    ),
                                  ),
                              errorText:
                                  state.errors[ReferralProgramRequestField
                                      .vacancy
                                      .name],
                            ),
                          const Gap(16),
                          AppTextField(
                            hint: 'ФИО кандидата',
                            errorText:
                                state.errors[ReferralProgramRequestField
                                    .candidateName
                                    .name],
                            controller: _candidateNameController,
                            focusNode: _candidateNameFocusNode,
                            onChanged:
                                (v) => bloc.add(
                                  ReferralProgramFieldChanged(
                                    ReferralProgramRequestField.candidateName,
                                    v,
                                  ),
                                ),
                          ),
                          const Gap(16),
                          AppTextField(
                            hint: 'Ссылка на резюме',
                            errorText:
                                state.errors[ReferralProgramRequestField
                                    .resumeLink
                                    .name],
                            controller: _resumeLinkController,
                            focusNode: _resumeLinkFocusNode,
                            onChanged:
                                (v) => bloc.add(
                                  ReferralProgramFieldChanged(
                                    ReferralProgramRequestField.resumeLink,
                                    v,
                                  ),
                                ),
                          ),
                          const Gap(16),
                          AppFileGrid(
                            files: files,
                            columns: 1,
                            title: 'Файл резюме',
                            subtitle:
                                'Максимальный размер загружаемого файла — 4 Мб',
                            mode: AppFileGridMode.edit,
                            onAddFile: () async {
                              final result = await FilePicker.platform
                                  .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf', 'doc', 'docx'],
                                    withData: true,
                                  );
                              if (result != null && result.files.isNotEmpty) {
                                final picked = result.files.first;
                                if (picked.size > 4 * 1024 * 1024) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Файл превышает 4 Мб!'),
                                    ),
                                  );
                                  return;
                                }
                                final file = ReferralResumeFile(
                                  name: picked.name,
                                  size: picked.size,
                                  url: picked.path ?? '',
                                  extension: picked.extension ?? '',
                                );
                                bloc.add(
                                  ReferralProgramFieldChanged(
                                    ReferralProgramRequestField.file,
                                    file,
                                  ),
                                );
                              }
                            },
                            onRemoveFile:
                                (_) => bloc.add(
                                  const ReferralProgramFieldChanged(
                                    ReferralProgramRequestField.file,
                                    null,
                                  ),
                                ),
                          ),
                          if (state.errors[ReferralProgramRequestField
                                  .file
                                  .name] !=
                              null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                state.errors[ReferralProgramRequestField
                                    .file
                                    .name]!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const Gap(16),
                          AppSwitch(
                            value: _showComment,
                            onChanged: (v) => setState(() => _showComment = v),
                            label: 'Добавить комментарий',
                          ),
                          if (_showComment)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: AppTextArea(
                                hint: 'Комментарий',
                                controller: _commentController,
                                focusNode: _commentFocusNode,
                                onChanged:
                                    (v) => bloc.add(
                                      ReferralProgramFieldChanged(
                                        ReferralProgramRequestField.comment,
                                        v,
                                      ),
                                    ),
                                errorText:
                                    state.errors[ReferralProgramRequestField
                                        .comment
                                        .name],
                              ),
                            ),
                          const Gap(32),
                        ],
                      ),
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
                      ReferralProgramRequestBloc,
                      ReferralProgramRequestState
                    >(
                      formKey: _formKey,
                      onSubmit: (context) {
                        FocusScope.of(context).unfocus();
                        context.read<ReferralProgramRequestBloc>().add(
                          ReferralProgramRequestSubmit(),
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
