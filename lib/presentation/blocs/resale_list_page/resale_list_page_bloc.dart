import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/models/models.dart';

part 'resale_list_page_event.dart';
part 'resale_list_page_state.dart';

class ResaleListPageBloc
    extends Bloc<ResaleListPageEvent, ResaleListPageState> {
  final FetchResaleItemsUseCase _getResaleItems;

  ResaleListPageBloc(this._getResaleItems)
    : super(ResaleListPageState.initial()) {
    on<LoadResaleListPage>(_onInitialLoad);
    on<FilterResaleListByStatus>(_onFilter);
    on<TapOnResaleListCardButton>(_onCardButtonTap);
    on<SearchFieldChangeResaleListPage>(_onSearchFieldChange);
  }

  Future<void> _onInitialLoad(
    LoadResaleListPage event,
    Emitter<ResaleListPageState> emit,
  ) async {
    final res = await _getResaleItems();

    final reserved = _mapItems(res.reserved, SaleStatus.reserved);
    final onSale = _mapItems(res.onSale, SaleStatus.onSale);
    final all = [...onSale, ...reserved];

    final grouped = {
      SaleStatus.all: all,
      SaleStatus.onSale: onSale,
      SaleStatus.reserved: reserved,
    };

    emit(
      state.copyWith(
        groupedItems: grouped,
        backupGroupedItems: grouped,
        selectedFilter: SaleStatus.all,
        filterTabs: _buildFilters(all.length, reserved.length),
      ),
    );
  }

  void _onFilter(
    FilterResaleListByStatus event,
    Emitter<ResaleListPageState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.status));
  }

  void _onCardButtonTap(
    TapOnResaleListCardButton event,
    Emitter<ResaleListPageState> emit,
  ) {
    final currentItem = event.item;
    final newStatus =
        currentItem.status == SaleStatus.onSale
            ? SaleStatus.reserved
            : SaleStatus.onSale;
    final updatedItem = currentItem.copyWith(status: newStatus);

    final allList =
        state.groupedItems[SaleStatus.all]!
            .map((item) => item.id == currentItem.id ? updatedItem : item)
            .toList();

    final onSale = allList.where((e) => e.status == SaleStatus.onSale).toList();
    final reserved =
        allList.where((e) => e.status == SaleStatus.reserved).toList();

    final grouped = {
      SaleStatus.all: allList,
      SaleStatus.onSale: onSale,
      SaleStatus.reserved: reserved,
    };

    emit(
      state.copyWith(
        groupedItems: grouped,
        filterTabs: _buildFilters(allList.length, reserved.length),
      ),
    );
  }

  void _onSearchFieldChange(
    SearchFieldChangeResaleListPage event,
    Emitter<ResaleListPageState> emit,
  ) {
    final query = event.text.trim().toLowerCase();
    if (query.isEmpty) {
      emit(state.copyWith(groupedItems: state.backupGroupedItems));
      return;
    }

    final all = state.backupGroupedItems[SaleStatus.all]!;
    final filteredAll =
        all.where((item) {
          return item.title.toLowerCase().contains(query) ||
              item.authorName.toLowerCase().contains(query);
        }).toList();

    final onSale =
        filteredAll.where((e) => e.status == SaleStatus.onSale).toList();
    final reserved =
        filteredAll.where((e) => e.status == SaleStatus.reserved).toList();

    final grouped = {
      SaleStatus.all: filteredAll,
      SaleStatus.onSale: onSale,
      SaleStatus.reserved: reserved,
    };

    emit(
      state.copyWith(
        groupedItems: grouped,
        filterTabs: _buildFilters(filteredAll.length, reserved.length),
      ),
    );
  }

  // Helpers
  List<ResaleItemModel> _mapItems(
    List<ResaleItemModel> data,
    SaleStatus status,
  ) => data.map((e) => e.copyWith(status: status)).toList();

  List<FilterTabModel<SaleStatus>> _buildFilters(int all, int reserved) => [
    FilterTabModel(label: 'Все', value: SaleStatus.all, count: all),
    FilterTabModel(
      label: 'Забронированные',
      value: SaleStatus.reserved,
      count: reserved,
    ),
  ];
}
