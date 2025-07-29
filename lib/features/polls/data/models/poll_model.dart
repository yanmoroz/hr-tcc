import '../../domain/entities/poll.dart';
import '../../domain/entities/poll_status.dart';

class PollModel {
  final int id;
  final String title;
  final String subtitle;
  final int passedCount;
  final String? imageUrl;
  final PollStatus status;
  final DateTime createdAt;

  const PollModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.passedCount,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  Poll toEntity() => Poll(
    id: id,
    title: title,
    subtitle: subtitle,
    passedCount: passedCount,
    imageUrl: imageUrl,
    status: status,
    createdAt: createdAt,
  );
}
