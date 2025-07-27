import 'package:hr_tcc/models/models.dart';

abstract class PollAnswerAbstractModel {
  final String questionId;
  final PollAnswerType type;

  const PollAnswerAbstractModel(this.questionId, this.type);

  Map<String, dynamic> toJson();
}
