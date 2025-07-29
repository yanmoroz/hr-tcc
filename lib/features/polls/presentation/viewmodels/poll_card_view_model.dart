import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/poll.dart';
import '../../domain/entities/poll_status.dart';

class PollCardViewModel {
  final String title;
  final String subtitle;
  final int passedCount;
  final String? imageUrl;
  final PollStatus status;
  final String createdAt;

  const PollCardViewModel({
    required this.title,
    required this.subtitle,
    required this.passedCount,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  factory PollCardViewModel.fromEntity(Poll poll) {
    final createdAt = AppDateUtils.formatRelativeTimestamp(poll.createdAt);

    return PollCardViewModel(
      title: poll.title,
      subtitle: poll.subtitle,
      passedCount: poll.passedCount,
      imageUrl: poll.imageUrl,
      status: poll.status,
      createdAt: createdAt,
    );
  }
}
