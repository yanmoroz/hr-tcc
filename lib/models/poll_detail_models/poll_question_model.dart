import 'package:hr_tcc/models/models.dart';

enum PollAnswerType {
  radioGroup,
  checkboxGroup,
  matrixRadio,
  modalSelector,
  fileGrid,
  textField,
}

// МОДЕЛЬ ВОПРОСА ДЛЯ ОПРОСА
// В зависимости от [type] используются разные поля:
//
// radio / checkbox     [options] (List<String>)
// matrix               [rows] + [columns]
// modalSelector        [modalOptions] (List<PollDetailOptionModel>)
// fileGrid             без дополнительных полей
class PollQuestionModel {
  final String id;
  final String? text;
  final String? hint;
  final List<PollAnswerType> types;
  final String? imageUrl;
  final List<bool>
  requiredTypes; // true - обязательный, false - необязательный вопрос

  // For radio / checkbox
  final List<PollDetailOptionModel> options;

  // For matrix
  final List<String> rows;
  final List<String> columns;

  // For modal selector
  final List<PollDetailOptionModel> modalOptions;

  // For text field
  final String? initialText;

  const PollQuestionModel({
    required this.id,
    this.text,
    required this.types,
    this.hint,
    this.imageUrl,
    this.requiredTypes = const [],
    this.options = const [],
    this.rows = const [],
    this.columns = const [],
    this.modalOptions = const [],
    this.initialText,
  });

  factory PollQuestionModel.fromJson(
    Map<String, dynamic> json,
  ) => PollQuestionModel(
    id: json['id'] as String,
    text: json['text'] as String?,
    hint: json['hint'] as String?,
    types:
        (json['types'] as List<dynamic>?)
            ?.map((e) => PollAnswerType.values.firstWhere((t) => t.name == e))
            .toList() ??
        (json['type'] != null
            ? [PollAnswerType.values.firstWhere((t) => t.name == json['type'])]
            : []),
    imageUrl: json['imageUrl'] as String?,
    requiredTypes:
        (json['requiredTypes'] as List<dynamic>?)
            ?.map((e) => e == true)
            .toList() ??
        List.filled((json['types'] as List<dynamic>?)?.length ?? 0, true),
    options:
        (json['options'] as List<dynamic>?)
            ?.map(
              (e) => PollDetailOptionModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        const [],
    rows: List<String>.from(json['rows'] as List<dynamic>? ?? const []),
    columns: List<String>.from(json['columns'] as List<dynamic>? ?? const []),
    modalOptions:
        (json['modalOptions'] as List<dynamic>?)
            ?.map(
              (e) => PollDetailOptionModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        const [],
    initialText: json['initialText'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (text != null) 'text': text,
    'hint': hint,
    'types': types.map((e) => e.name).toList(),
    'requiredTypes': requiredTypes,
    if (imageUrl != null) 'imageUrl': imageUrl,
    if (options.isNotEmpty) 'options': options.map((e) => e.toJson()).toList(),
    if (rows.isNotEmpty) 'rows': rows,
    if (columns.isNotEmpty) 'columns': columns,
    if (modalOptions.isNotEmpty)
      'modalOptions': modalOptions.map((e) => e.toJson()).toList(),
    if (initialText != null) 'initialText': initialText,
  };
}
