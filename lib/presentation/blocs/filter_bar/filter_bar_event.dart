part of 'filter_bar_bloc.dart';

abstract class FilterEvent {}

class FilterTabSelected extends FilterEvent {
  final int selectedIndex;

  FilterTabSelected(this.selectedIndex);
}

class SetFilterTabs<T> extends FilterEvent {
  final List<FilterTabModel<T>> tabs;

  SetFilterTabs(this.tabs);
}

class UpdateTabCounts<T> extends FilterEvent {
  final List<int?> counts;
  UpdateTabCounts(this.counts);
}
