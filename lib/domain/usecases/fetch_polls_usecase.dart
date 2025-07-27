import 'package:hr_tcc/domain/models/models.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class FetchPollsListUseCase {
  final PollRepository _pollRepository;

  FetchPollsListUseCase(this._pollRepository);

  Future<PollsApiResponse> call({
    required int page,
    required int pageSize,
  }) async {
    return await _pollRepository.fetchPolls(page: page, pageSize: pageSize);
  }
}
