part of 'more_page_bloc.dart';

abstract class MorePageState {}

class MorePageInitial extends MorePageState {}

class MorePageLoading extends MorePageState {}

class MorePageLoaded extends MorePageState {
  final List<MoreCardModel> cards;

  MorePageLoaded(this.cards);
}