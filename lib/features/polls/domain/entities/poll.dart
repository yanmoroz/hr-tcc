import 'poll_question.dart';

class Poll {
  final String id;
  final String title;
  final String? subtitle; // e.g., under-title text or partner info
  final String? description;
  final DateTime publishedAt;
  final bool isCompleted;
  final int participantCount;
  final String? imageUrl;

  final List<PollQuestion>? questions; // optional for list view

  const Poll({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    required this.publishedAt,
    required this.isCompleted,
    required this.participantCount,
    this.imageUrl,
    this.questions,
  });
}
