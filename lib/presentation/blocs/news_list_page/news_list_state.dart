part of 'news_list_bloc.dart';

abstract class NewsListState {}

class NewsListLoading extends NewsListState {}

class NewsListLoaded extends NewsListState {
  final List<NewsCardModel> news;
  final bool hasReachedMax;
  final NewsCategory selectedCategory;
  final String searchQuery;
  NewsListLoaded({
    required this.news,
    required this.hasReachedMax,
    required this.selectedCategory,
    required this.searchQuery,
  });

  NewsListLoaded copyWith({
    List<NewsCardModel>? news,
    bool? hasReachedMax,
    NewsCategory? selectedCategory,
    String? searchQuery,
  }) {
    return NewsListLoaded(
      news: news ?? this.news,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class NewsListLoadingInProgress extends NewsListState {
  final NewsCategory selectedCategory;
  final String searchQuery;

  NewsListLoadingInProgress({
    required this.selectedCategory,
    required this.searchQuery,
  });
}

class NewsListError extends NewsListState {
  final String message;
  NewsListError(this.message);
}