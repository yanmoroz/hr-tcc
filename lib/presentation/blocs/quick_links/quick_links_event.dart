part of 'quick_links_bloc.dart';

abstract class QuickLinksEvent {}

class LoadQuickLinks extends QuickLinksEvent {}

class QuickLinkClicked extends QuickLinksEvent {
  final String link;

  QuickLinkClicked(this.link);
}