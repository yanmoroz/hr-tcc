part of 'news_list_bloc.dart';

abstract class NewsListEvent {}

class LoadInitialNewsList extends NewsListEvent {}

class LoadMoreNewsList extends NewsListEvent {}

class ChangeCategoryNewsList extends NewsListEvent {
  final NewsCategory category;
  ChangeCategoryNewsList(this.category);
}

class SearchQueryChangedNewsList extends NewsListEvent {
  final String query;
  SearchQueryChangedNewsList(this.query);
}
