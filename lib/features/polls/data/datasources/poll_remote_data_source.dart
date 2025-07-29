import '../../../../core/common/paged_result.dart';
import '../models/poll_model.dart';

abstract class PollRemoteDataSource {
  Future<PagedResult<PollModel>> fetchPolls({
    required int page,
    required int pageSize,
    required bool? isCompleted,
  });
}
