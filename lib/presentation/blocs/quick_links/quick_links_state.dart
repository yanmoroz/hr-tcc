part of 'quick_links_bloc.dart';

abstract class QuickLinksState {}

class QuickLinksInitial extends QuickLinksState {}

class QuickLinksLoaded extends QuickLinksState {
  final List<QuickLinkModel> links;
  QuickLinksLoaded(this.links);
}