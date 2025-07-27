part of 'news_section_bloc.dart';

abstract class NewsSectionState {}

class NewsSectionInitial extends NewsSectionState {}

class NewsSectionLoading extends NewsSectionState {}

class NewsSectionLoaded extends NewsSectionState {
  final List<NewsCardModel> news;

  NewsSectionLoaded(this.news);
}

class NewsSectionError extends NewsSectionState {
  final String message;

  NewsSectionError(this.message);
}