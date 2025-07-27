import 'package:hr_tcc/domain/models/models.dart';
import 'package:hr_tcc/models/models.dart';

abstract class NewsListRepository {
  Future<NewsListApiResponse> fetchNewsList ({
    required int page,
    required int pageSize,
    NewsCategory category = NewsCategory.all,
    String query = '',
  });
}
