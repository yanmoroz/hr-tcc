import '../../domain/entities/poll_question.dart';

class PollQuestionModel extends PollQuestion {
  PollQuestionModel({
    required super.id,
    required super.text,
    required super.type,
    super.answer,
  });

  factory PollQuestionModel.fromJson(Map<String, dynamic> json) {
    return PollQuestionModel(
      id: json['id'],
      text: json['text'],
      type: PollQuestionType.values.byName(json['type']),
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'type': type.name,
    'answer': answer,
  };
}
