import '../../domain/entities/poll.dart';
import 'poll_question_model.dart';

class PollModel extends Poll {
  PollModel({
    required super.id,
    required super.title,
    super.subtitle,
    super.description,
    required super.publishedAt,
    required super.isCompleted,
    required super.participantCount,
    super.imageUrl,
    super.questions,
  });

  factory PollModel.fromJson(Map<String, dynamic> json) {
    return PollModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      publishedAt: DateTime.parse(json['published_at']),
      isCompleted: json['is_completed'],
      participantCount: json['participant_count'],
      imageUrl: json['image_url'],
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((q) => PollQuestionModel.fromJson(q))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'published_at': publishedAt.toIso8601String(),
    'is_completed': isCompleted,
    'participant_count': participantCount,
    'image_url': imageUrl,
    'questions':
        questions
            ?.map(
              (q) => {
                'id': q.id,
                'text': q.text,
                'type': q.type.name,
                'answer': q.answer,
              },
            )
            .toList(),
  };
}
