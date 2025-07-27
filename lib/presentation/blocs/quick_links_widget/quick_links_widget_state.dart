part of 'quick_links_widget_bloc.dart';

abstract class QuickLinksWidgetState {}

class QuickLinksWidgetInitial extends QuickLinksWidgetState {}

class QuickLinksWidgetLoaded extends QuickLinksWidgetState {
  final List<QuickLinkModel> links;

  QuickLinksWidgetLoaded({required this.links});
}