part of 'resale_list_page_bloc.dart';

class ResaleListPageState {
  final Map<SaleStatus, List<ResaleItemModel>> groupedItems;
  final Map<SaleStatus, List<ResaleItemModel>> backupGroupedItems;
  final SaleStatus selectedFilter;
  final List<FilterTabModel<SaleStatus>> filterTabs;

  const ResaleListPageState({
    required this.groupedItems,
    required this.backupGroupedItems,
    required this.selectedFilter,
    required this.filterTabs,
  });

  factory ResaleListPageState.initial() => const ResaleListPageState(
    groupedItems: {},
    backupGroupedItems: {},
    selectedFilter: SaleStatus.onSale,
    filterTabs: <FilterTabModel<SaleStatus>>[],
  );

  ResaleListPageState copyWith({
    Map<SaleStatus, List<ResaleItemModel>>? groupedItems,
    Map<SaleStatus, List<ResaleItemModel>>? backupGroupedItems,
    SaleStatus? selectedFilter,
    List<FilterTabModel<SaleStatus>>? filterTabs,
  }) {
    return ResaleListPageState(
      groupedItems: groupedItems ?? this.groupedItems,
      backupGroupedItems: backupGroupedItems ?? this.backupGroupedItems,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      filterTabs: filterTabs ?? this.filterTabs,
    );
  }
}
