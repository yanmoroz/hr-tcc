import '../../../../core/common/paged_result.dart';
import '../entities/poll.dart';

abstract class PollRepository {
  Future<PagedResult<Poll>> getPolls({
    int page = 1,
    int pageSize = 10,
    bool? isCompleted,
  });
}
