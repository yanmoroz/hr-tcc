part of 'quick_links_widget_bloc.dart';

abstract class QuickLinksWidgetEvent {}

class LoadQuickWidgetLinks extends QuickLinksWidgetEvent {}

class QuickLinksWidgetOpenLink extends QuickLinksWidgetEvent {
  final String link;

  QuickLinksWidgetOpenLink(this.link);
}
