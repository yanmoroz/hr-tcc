import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/pages/poll_detail_page/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

// WIDGET‑КОНСТРУКТОР ДЛЯ ОДНОГО ВОПРОСА
class PollDetailQuestionWidget extends StatelessWidget {
  final PollQuestionModel question;
  final List<PollAnswerAbstractModel> answers;
  final ValueChanged<PollAnswerAbstractModel> onChanged;

  const PollDetailQuestionWidget({
    super.key,
    required this.question,
    required this.answers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((question.text?.isNotEmpty ?? false))
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Показываем звездочку, если хотя бы один тип обязательный
              if (question.requiredTypes.isNotEmpty &&
                  question.requiredTypes.any((r) => r))
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 2),
                  child: Text(
                    '* ',
                    style: AppTypography.text1Medium.copyWith(
                      color: AppColors.red500,
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  question.text ?? '',
                  style: AppTypography.text1Medium,
                ),
              ),
            ],
          ),
        if (question.imageUrl?.isNotEmpty ?? false) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: question.imageUrl ?? '',
              fit: BoxFit.cover,
              height: 128,
              placeholder:
                  (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              errorWidget:
                  (context, url, error) => const Icon(Icons.image, size: 48),
            ),
          ),
        ],
        if (question.hint?.isNotEmpty ?? false) ...[
          const SizedBox(height: 4),
          Text(
            question.hint ?? '',
            style: AppTypography.text2Regular.copyWith(
              color: AppColors.gray700,
            ),
          ),
        ],
        const SizedBox(height: 12),
        ..._buildAnswerWidgets(),
      ],
    );
  }

  List<Widget> _buildAnswerWidgets() {
    final widgets = <Widget>[];

    for (var i = 0; i < question.types.length; i++) {
      if (i > 0) widgets.add(const SizedBox(height: 8));

      final type = question.types[i];
      final answer = (i < answers.length) ? answers[i] : null;

      switch (type) {
        case PollAnswerType.radioGroup:
          widgets.add(
            PollsDetailRadioGroup(
              options: question.options,
              value: (answer is RadioAnswerModel) ? answer.selectedId : null,
              onChanged: (selected) {
                onChanged(
                  RadioAnswerModel(
                    questionId: question.id,
                    selectedId: selected,
                  ),
                );
              },
            ),
          );
          break;

        case PollAnswerType.checkboxGroup:
          widgets.add(
            PollsDetailCheckboxGroup(
              options: question.options,
              selectedValues:
                  (answer is CheckboxAnswerModel)
                      ? answer.selectedIds
                      : const [],
              onChanged: (vals) {
                onChanged(
                  CheckboxAnswerModel(
                    questionId: question.id,
                    selectedIds: vals,
                  ),
                );
              },
            ),
          );
          break;

        case PollAnswerType.matrixRadio:
          widgets.add(
            PollsDetailMatrixRadio(
              rows: question.rows,
              columns: question.columns,
              values:
                  (answer is MatrixRadioAnswerModel) ? answer.values : const {},
              onChanged: (rowIdx, colVal) {
                final oldValues =
                    (answer is MatrixRadioAnswerModel)
                        ? Map<int, String?>.from(answer.values)
                        : <int, String?>{};
                oldValues[rowIdx] = colVal;
                onChanged(
                  MatrixRadioAnswerModel(
                    questionId: question.id,
                    values: oldValues,
                  ),
                );
              },
            ),
          );
          break;

        case PollAnswerType.modalSelector:
          final selectedOptionId =
              (answer is SelectorAnswerModel) ? answer.selectedId : null;
          final selectedOption = question.modalOptions.firstWhere(
            (o) => o.id == selectedOptionId,
            orElse: () => const PollDetailOptionModel(id: '', title: ''),
          );
          widgets.add(
            AppModalSelector<PollDetailOptionModel>(
              title: 'Выберите вариант',
              items: question.modalOptions,
              selected: selectedOption.id.isEmpty ? null : selectedOption,
              itemLabel: (o) => o.title ?? '',
              subtitleLabel: (o) => o.subTitle,
              onSelected: (opt) {
                onChanged(
                  SelectorAnswerModel(
                    questionId: question.id,
                    selectedId: opt.id,
                  ),
                );
              },
            ),
          );
          break;

        case PollAnswerType.fileGrid:
          widgets.add(
            PollDetailFileGrid(
              files: (answer is FileGridAnswerModel) ? answer.files : const [],
              onFilesChanged: (newFiles) {
                onChanged(
                  FileGridAnswerModel(questionId: question.id, files: newFiles),
                );
              },
            ),
          );
          break;

        case PollAnswerType.textField:
          widgets.add(
            PollDetailTextField(
              onChanged: (val) {
                onChanged(
                  TextFieldAnswerModel(questionId: question.id, text: val),
                );
              },
            ),
          );
          break;
      }
    }

    return widgets;
  }
}
