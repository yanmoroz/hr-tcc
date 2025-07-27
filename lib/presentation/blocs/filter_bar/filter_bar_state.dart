part of 'filter_bar_bloc.dart';

class FilterState<T> {
  final int selectedIndex;
  final List<FilterTabModel<T>> tabs;

  FilterState({required this.selectedIndex, required this.tabs});

  FilterState<T> copyWith({int? selectedIndex, List<FilterTabModel<T>>? tabs}) {
    return FilterState<T>(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      tabs: tabs ?? this.tabs,
    );
  }

  FilterTabModel<T> get selectedTab => tabs[selectedIndex];
}
