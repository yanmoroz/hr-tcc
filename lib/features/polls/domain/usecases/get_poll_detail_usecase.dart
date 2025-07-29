import '../entities/poll.dart';
import '../repositories/poll_repository.dart';

class GetPollDetailUseCase {
  final PollRepository repository;

  GetPollDetailUseCase(this.repository);

  Future<Poll> call(String id) => repository.getPollDetail(id);
}
