import 'poll_status.dart';

class Poll {
  final int id;
  final String title;
  final String subtitle;
  final int passedCount;
  final String? imageUrl;
  final PollStatus status;
  final DateTime createdAt;

  const Poll({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.passedCount,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });
}
