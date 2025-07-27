import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:intl/intl.dart';

part 'news_list_event.dart';
part 'news_list_state.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  static const int _pageSize = 20;
  int _currentPage = 1;

  final FetchNewsListUseCase fetchNewsListUseCase;

  NewsListBloc({required this.fetchNewsListUseCase})
    : super(NewsListLoading()) {
    on<LoadInitialNewsList>(_onLoadInitialNews);
    on<LoadMoreNewsList>(_onLoadMoreNews);
    on<ChangeCategoryNewsList>(_onChangeCategory);
    on<SearchQueryChangedNewsList>(_onSearchQueryChanged);
  }

  Future<void> _onLoadInitialNews(
    LoadInitialNewsList event,
    Emitter<NewsListState> emit,
  ) async {
    await _loadNews(emit: emit, category: NewsCategory.all, query: '');
  }

  Future<void> _onChangeCategory(
    ChangeCategoryNewsList event,
    Emitter<NewsListState> emit,
  ) async {
    final currentQuery = _currentSearchQuery;
    await _loadNews(emit: emit, category: event.category, query: currentQuery);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedNewsList event,
    Emitter<NewsListState> emit,
  ) async {
    final currentCategory = _currentCategory;
    await _loadNews(emit: emit, category: currentCategory, query: event.query);
  }

  Future<void> _onLoadMoreNews(
    LoadMoreNewsList event,
    Emitter<NewsListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NewsListLoaded || currentState.hasReachedMax) return;

    _currentPage++;
    try {
      final newNews = await fetchNewsListUseCase(
        page: _currentPage,
        pageSize: _pageSize,
        category: currentState.selectedCategory,
        query: currentState.searchQuery,
      );

      final combinedNews = [...currentState.news, ...newNews.listNews];

      emit(
        currentState.copyWith(
          news: combinedNews,
          hasReachedMax: newNews.listNews.length < _pageSize,
        ),
      );
    } on Exception catch (e, _) {
      emit(NewsListError(e.toString()));
    }
  }

  Future<void> _loadNews({
    required Emitter<NewsListState> emit,
    required NewsCategory category,
    required String query,
  }) async {
    emit(
      NewsListLoadingInProgress(selectedCategory: category, searchQuery: query),
    );

    try {
      _currentPage = 1;
      final news = await fetchNewsListUseCase(
        page: _currentPage,
        pageSize: _pageSize,
        category: category,
        query: query,
      );
      emit(
        NewsListLoaded(
          news: news.listNews,
          hasReachedMax: news.listNews.length < _pageSize,
          selectedCategory: category,
          searchQuery: query,
        ),
      );
    } on Exception catch (e, _) {
      emit(NewsListError(e.toString()));
    }
  }

  NewsCategory get _currentCategory {
    if (state case NewsListLoaded s) return s.selectedCategory;
    if (state case NewsListLoadingInProgress s) return s.selectedCategory;
    return NewsCategory.all;
  }

  String get _currentSearchQuery {
    if (state case NewsListLoaded s) return s.searchQuery;
    if (state case NewsListLoadingInProgress s) return s.searchQuery;
    return '';
  }

  Map<String, List<NewsCardModel>> groupNews(List<NewsCardModel> news) {
    final Map<String, List<NewsCardModel>> grouped = {};

    for (final item in news) {
      final date = _parseDateFromString(item.time);
      final label = _getDateGroupLabel(date);
      grouped.putIfAbsent(label, () => []).add(item);
    }

    return grouped;
  }

  String _getDateGroupLabel(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0 && now.day == date.day) {
      return 'Сегодня';
    } else if (diff.inDays == 1 ||
        (diff.inHours < 48 && now.day - date.day == 1)) {
      return 'Вчера';
    } else {
      return 'Ранее';
    }
  }

  DateTime _parseDateFromString(String timeStr) {
    final now = DateTime.now();

    if (timeStr.startsWith('Сегодня')) {
      final time = _extractTime(timeStr);
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    } else if (timeStr.startsWith('Вчера')) {
      final time = _extractTime(timeStr);
      final yesterday = now.subtract(const Duration(days: 1));
      return DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
        time.hour,
        time.minute,
      );
    } else {
      try {
        final cleaned = timeStr.replaceAll(' в ', ' ');
        return DateFormat('d MMMM yyyy HH:mm', 'ru').parseStrict(cleaned);
      } on Exception catch (e, _) {
        debugPrint('Не удалось распарсить дату: "$timeStr". Ошибка: $e');
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }
  }

  TimeOfDay _extractTime(String str) {
    final reg = RegExp(r'(\d{1,2}):(\d{2})');
    final match = reg.firstMatch(str);
    if (match != null) {
      final hour = int.tryParse(match.group(1) ?? '') ?? 0;
      final minute = int.tryParse(match.group(2) ?? '') ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }
}
