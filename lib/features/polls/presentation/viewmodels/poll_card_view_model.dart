import 'package:intl/intl.dart';

import '../../domain/entities/poll.dart';

class PollCardViewModel {
  final String title;
  final String subtitle;
  final int passedCount;
  final String? imageUrl;
  final bool isCompleted;
  final String createdAt;

  const PollCardViewModel({
    required this.title,
    required this.subtitle,
    required this.passedCount,
    this.imageUrl,
    required this.isCompleted,
    required this.createdAt,
  });

  factory PollCardViewModel.fromEntity(Poll poll) {
    final createdAt = formatPollTimestamp(poll.createdAt);

    return PollCardViewModel(
      title: poll.title,
      subtitle: poll.subtitle,
      passedCount: poll.passedCount,
      imageUrl: poll.imageUrl,
      isCompleted: poll.isCompleted,
      createdAt: createdAt,
    );
  }

  static String formatPollTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

    final difference = today.difference(date).inDays;

    final timePart = DateFormat('HH:mm', 'ru').format(timestamp);

    if (difference == 0) {
      return 'Сегодня в $timePart';
    } else if (difference == 1) {
      return 'Вчера в $timePart';
    } else {
      final datePart = DateFormat(
        'dd MMMM',
        'ru',
      ).format(timestamp); // e.g. "27 июля"
      return '$datePart в $timePart';
    }
  }
}
