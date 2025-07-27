import 'package:hr_tcc/models/models.dart';

class CheckboxAnswerModel extends PollAnswerAbstractModel {
  final List<String> selectedIds;

  const CheckboxAnswerModel({
    required String questionId,
    this.selectedIds = const [],
  }) : super(questionId, PollAnswerType.checkboxGroup);

  factory CheckboxAnswerModel.fromJson(Map<String, dynamic> json) =>
      CheckboxAnswerModel(
        questionId: json['questionId'] as String,
        selectedIds: List<String>.from(json['selectedIds'] as List<dynamic>),
      );

  @override
  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'type': type.name,
    'selectedIds': selectedIds,
  };
}
