import '../../../../core/common/paged_result.dart';
import '../entities/poll.dart';
import '../entities/poll_status.dart';
import '../repositories/poll_repository.dart';

class GetPollsUseCase {
  final PollRepository repository;

  GetPollsUseCase(this.repository);

  Future<PagedResult<Poll>> call({
    int page = 1,
    int pageSize = 10,
    PollStatus? status,
  }) => repository.getPolls(page: page, pageSize: pageSize, status: status);
}
