import '../../../../core/common/paged_result.dart';
import '../../domain/entities/poll.dart';
import '../../domain/entities/poll_status.dart';
import '../../domain/repositories/poll_repository.dart';
import '../datasources/poll_remote_data_source.dart';

class PollRepositoryImpl implements PollRepository {
  final PollRemoteDataSource remoteDataSource;

  PollRepositoryImpl(this.remoteDataSource);

  @override
  Future<PagedResult<Poll>> getPolls({
    int page = 1,
    int pageSize = 10,
    PollStatus? status,
  }) async {
    final result = await remoteDataSource.fetchPolls(
      page: page,
      pageSize: pageSize,
      status: status,
    );

    return PagedResult<Poll>(
      items: result.items.map((pollModel) => pollModel.toEntity()).toList(),
      totalCount: result.totalCount,
      hasMore: result.hasMore,
    );
  }
}
