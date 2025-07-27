import 'package:hr_tcc/domain/models/news_list_api_response.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/models/news_card_model.dart';

class NewsListRepositoryImp implements NewsListRepository {
  @override
  Future<NewsListApiResponse> fetchNewsList({
    required int page,
    required int pageSize,
    NewsCategory category = NewsCategory.all,
    String query = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 300)); // эмуляция сети
    var filtered = _mockNews();

    if (category != NewsCategory.all) {
      filtered = filtered.where((n) => n.category == category).toList();
    }

    if (query.isNotEmpty) {
      filtered =
          filtered
              .where(
                (n) =>
                    n.title.toLowerCase().contains(query.toLowerCase()) ||
                    n.subtitle.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }

    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    if (start >= filtered.length) return NewsListApiResponse(listNews: []);

    return NewsListApiResponse(
      listNews: filtered.sublist(start, end.clamp(0, filtered.length)),
    );
  }

  List<NewsCardModel> _mockNews() => [
    NewsCardModel(
      id: 1,
      time: 'Сегодня в 08:20',
      title: 'Стандарт интеграции утвержден',
      subtitle: 'Стандарт интеграции информационных систем…',
      category: NewsCategory.s8News,
      imageUrl: 'https://placehold.co/600x400@2x.png',
      notRead: true,
    ),
    NewsCardModel(
      id: 2,
      time: 'Вчера в 16:45',
      title: 'Вышло обновление приложения',
      subtitle: 'Новое обновление включает улучшения интерфейса…',
      category: NewsCategory.s8Processes,
      imageUrl: 'https://placehold.co/600x400@2x.png',
      notRead: false,
    ),
    NewsCardModel(
      id: 3,
      time: '12 июня 2025 в 08:00',
      title: 'Будущая новость',
      subtitle: 'Демонстрация парсинга конкретной даты.',
      category: NewsCategory.s8News,
      imageUrl: 'https://placehold.co/600x400@2x.png',
      notRead: false,
    ),
  ];
}
