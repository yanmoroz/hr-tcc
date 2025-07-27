import 'package:hr_tcc/models/models.dart';

class TextFieldAnswerModel extends PollAnswerAbstractModel {
  final String text;

  const TextFieldAnswerModel({required String questionId, this.text = ''})
    : super(questionId, PollAnswerType.textField);

  factory TextFieldAnswerModel.fromJson(Map<String, dynamic> json) =>
      TextFieldAnswerModel(
        questionId: json['questionId'] as String,
        text: json['text'] as String? ?? '',
      );

  @override
  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'type': type.name,
    'text': text,
  };
}
