import 'package:hr_tcc/domain/models/models.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/models/models.dart';

class FetchNewsListUseCase {
  final NewsListRepository _newsListRepository;

  FetchNewsListUseCase(this._newsListRepository);

  Future<NewsListApiResponse> call({
    required int page,
    required int pageSize,
    NewsCategory category = NewsCategory.all,
    String query = '',
  }) async {
    return await _newsListRepository.fetchNewsList(
      page: page,
      pageSize: pageSize,
      category: category,
      query: query,
    );
  }
}
