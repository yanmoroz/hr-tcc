import '../../domain/entities/poll.dart';

class PollModel extends Poll {
  const PollModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.passedCount,
    super.imageUrl,
    required super.isCompleted,
    required super.createdAt,
  });
}
