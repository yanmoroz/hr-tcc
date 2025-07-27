import 'package:hr_tcc/models/models.dart';

class RadioAnswerModel extends PollAnswerAbstractModel {
  final String? selectedId;

  const RadioAnswerModel({required String questionId, this.selectedId})
    : super(questionId, PollAnswerType.radioGroup);

  factory RadioAnswerModel.fromJson(Map<String, dynamic> json) =>
      RadioAnswerModel(
        questionId: json['questionId'] as String,
        selectedId: json['selectedId'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'type': type.name,
    'selectedId': selectedId,
  };
}
