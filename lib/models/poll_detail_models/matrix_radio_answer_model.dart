import 'package:hr_tcc/models/models.dart';

class MatrixRadioAnswerModel extends PollAnswerAbstractModel {
  // ключ — индекс строки, значение выбранный id колонки
  final Map<int, String?> values;

  const MatrixRadioAnswerModel({
    required String questionId,
    this.values = const {},
  }) : super(questionId, PollAnswerType.matrixRadio);

  factory MatrixRadioAnswerModel.fromJson(Map<String, dynamic> json) =>
      MatrixRadioAnswerModel(
        questionId: json['questionId'] as String,
        values:
            (json['values'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(int.parse(k), v as String?),
            ) ??
            {},
      );

  @override
  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'type': type.name,
    'values': values.map((k, v) => MapEntry(k.toString(), v)),
  };
}
