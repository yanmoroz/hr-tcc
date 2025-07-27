import 'package:hr_tcc/models/models.dart';

class SelectorAnswerModel extends PollAnswerAbstractModel {
  final String? selectedId;

  const SelectorAnswerModel({required String questionId, this.selectedId})
    : super(questionId, PollAnswerType.modalSelector);

  factory SelectorAnswerModel.fromJson(Map<String, dynamic> json) =>
      SelectorAnswerModel(
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
