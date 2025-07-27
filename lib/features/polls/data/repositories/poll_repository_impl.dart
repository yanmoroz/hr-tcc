import '../../domain/entities/poll.dart';
import '../../domain/repositories/poll_repository.dart';
import '../models/poll_model.dart';

class PollRepositoryImpl implements PollRepository {
  @override
  Future<List<Poll>> fetchPolls() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      PollModel(
        id: '1',
        title: 'Workplace Feedback',
        description: 'Tell us how you feel about the workspace.',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        hasVoted: false,
      ),
      PollModel(
        id: '2',
        title: 'Lunch Options',
        description: 'Vote for next month’s lunch menu!',
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        hasVoted: true,
      ),
    ];
  }
}
