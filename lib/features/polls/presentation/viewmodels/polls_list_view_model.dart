import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/poll.dart';
import '../../domain/entities/poll_status.dart';

class PollsListViewModel {
  final List<PollListItemViewModel> polls;

  PollsListViewModel._(this.polls);

  factory PollsListViewModel.fromEntities(List<Poll> entities) {
    final items = entities.map(PollListItemViewModel.fromEntity).toList();
    return PollsListViewModel._(items);
  }
}

class PollListItemViewModel {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String createdAt;
  final PollStatus status;

  const PollListItemViewModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.createdAt,
    required this.status,
  });

  factory PollListItemViewModel.fromEntity(Poll poll) {
    final createdAt = AppDateUtils.formatRelativeTimestamp(poll.createdAt);

    return PollListItemViewModel(
      title: poll.title,
      subtitle: poll.subtitle,
      imageUrl: poll.imageUrl,
      createdAt: createdAt,
      status: poll.status,
    );
  }
}
