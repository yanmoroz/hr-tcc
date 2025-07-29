import '../../domain/entities/poll.dart';

class PollModel {
  final int id;
  final String title;
  final String subtitle;
  final int passedCount;
  final String? imageUrl;
  final bool isCompleted;
  final DateTime createdAt;

  const PollModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.passedCount,
    this.imageUrl,
    required this.isCompleted,
    required this.createdAt,
  });

  Poll toEntity() => Poll(
    id: id,
    title: title,
    subtitle: subtitle,
    passedCount: passedCount,
    imageUrl: imageUrl,
    isCompleted: isCompleted,
    createdAt: createdAt,
  );
}
