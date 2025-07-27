import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_typography.dart';
import '../../../blocs/bloc_factory.dart';
import '../../../blocs/violation_request/violation_request_bloc.dart';
import '../../../widgets/common/app_file_grid/app_file_grid.dart';
import '../../../widgets/common/app_switch/app_switch.dart';
import '../../../widgets/common/app_text_area/app_text_area.dart';
import '../../../widgets/common/app_text_field/app_text_field.dart';
import '../components/components.dart';

class ViolationRequestCreatePage extends StatelessWidget {
  const ViolationRequestCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocFactory.createViolationRequestBloc(),
      child: _ViolationRequestCreateView(),
    );
  }
}

class _ViolationRequestCreateView extends StatelessWidget {
  _ViolationRequestCreateView();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _subjectFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _subjectFocusNode.addListener(() {
      if (!_subjectFocusNode.hasFocus) {
        context.read<ViolationRequestBloc>().add(
          ViolationRequestFieldBlurred(ViolationRequestField.subject),
        );
      }
    });
    _descriptionFocusNode.addListener(() {
      if (!_descriptionFocusNode.hasFocus) {
        context.read<ViolationRequestBloc>().add(
          ViolationRequestFieldBlurred(ViolationRequestField.description),
        );
      }
    });
    return BlocListener<ViolationRequestBloc, ViolationRequestState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          FocusScope.of(context).unfocus();
          context.pop(true);
        }
      },
      child: BlocBuilder<ViolationRequestBloc, ViolationRequestState>(
        builder: (context, state) {
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
                            const Gap(8),
                            Text('Нарушение', style: AppTypography.title2Bold),
                            const Gap(24),
                            AppSwitch(
                              label: 'Конфиденциальная заявка',
                              value: state.isConfidential,
                              onChanged:
                                  (v) =>
                                      context.read<ViolationRequestBloc>().add(
                                        ViolationRequestCheckboxChanged(
                                          value: v,
                                        ),
                                      ),
                            ),
                            const Gap(16),
                            AppTextField(
                              hint: 'Тема нарушения',
                              focusNode: _subjectFocusNode,
                              onChanged:
                                  (v) =>
                                      context.read<ViolationRequestBloc>().add(
                                        ViolationRequestFieldChanged(
                                          ViolationRequestField.subject,
                                          v,
                                        ),
                                      ),
                              errorText:
                                  state.errors[ViolationRequestField.subject],
                            ),
                            const Gap(16),
                            AppTextArea(
                              hint: 'Описание нарушения',
                              focusNode: _descriptionFocusNode,
                              onChanged:
                                  (v) =>
                                      context.read<ViolationRequestBloc>().add(
                                        ViolationRequestFieldChanged(
                                          ViolationRequestField.description,
                                          v,
                                        ),
                                      ),
                              errorText:
                                  state.errors[ViolationRequestField
                                      .description],
                            ),
                            const Gap(24),
                            const Text('Файлы'),
                            const Text(
                              'Максимальный размер загружаемого файла — 4 Мб',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            AppFileGrid(
                              files: state.files,
                              onAddFile: () async {
                                final mounted =
                                    context.mounted; // capture before async
                                final result = await FilePicker.platform
                                    .pickFiles(withData: true);
                                if (!mounted ||
                                    result == null ||
                                    result.files.isEmpty) {
                                  return;
                                }
                                final file = result.files.first;
                                final extension =
                                    file.extension?.toLowerCase() ?? '';
                                final isImage = [
                                  'jpg',
                                  'jpeg',
                                  'png',
                                  'gif',
                                  'heic',
                                  'bmp',
                                  'webp',
                                ].contains(extension);
                                final item = AppFileGridItem(
                                  name: file.name,
                                  extension: extension,
                                  sizeBytes: file.size,
                                  status: AppFileUploadStatus.success,
                                  previewImage:
                                      (isImage && file.path != null)
                                          ? FileImage(File(file.path!))
                                          : null,
                                  progress: 1.0,
                                );
                                if (context.mounted) {
                                  // check again after async
                                  context.read<ViolationRequestBloc>().add(
                                    ViolationRequestFilesChanged([
                                      ...state.files,
                                      item,
                                    ]),
                                  );
                                }
                              },
                              mode: AppFileGridMode.edit,
                            ),
                            const Gap(80),
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
                      ViolationRequestBloc,
                      ViolationRequestState
                    >(
                      formKey: _formKey,
                      onSubmit: (context) {
                        FocusScope.of(context).unfocus();
                        context.read<ViolationRequestBloc>().add(
                          ViolationRequestSubmit(),
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
