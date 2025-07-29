import '../../../../core/common/paged_result.dart';
import '../../domain/entities/poll.dart';
import '../../domain/repositories/poll_repository.dart';
import '../datasources/poll_remote_data_source.dart';

class PollRepositoryImpl implements PollRepository {
  final PollRemoteDataSource remoteDataSource;

  PollRepositoryImpl(this.remoteDataSource);

  @override
  Future<PagedResult<Poll>> getPolls({
    int page = 1,
    int pageSize = 10,
    bool? isCompleted,
  }) {
    return remoteDataSource.fetchPolls(
      page: page,
      pageSize: pageSize,
      isCompleted: isCompleted,
    );
  }
}
