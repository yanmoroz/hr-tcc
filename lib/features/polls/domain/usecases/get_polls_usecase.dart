import '../entities/poll.dart';
import '../repositories/poll_repository.dart';

class GetPollsUseCase {
  final PollRepository repository;

  GetPollsUseCase(this.repository);

  Future<List<Poll>> call() => repository.getPolls();
}
