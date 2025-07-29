import '../../../../core/common/paged_result.dart';
import '../entities/poll.dart';
import '../entities/poll_status.dart';

abstract class PollRepository {
  Future<PagedResult<Poll>> getPolls({
    int page = 1,
    int pageSize = 10,
    PollStatus? status,
  });
}
