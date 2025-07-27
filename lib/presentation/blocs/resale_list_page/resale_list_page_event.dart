part of 'resale_list_page_bloc.dart';

abstract class ResaleListPageEvent {}

class LoadResaleListPage extends ResaleListPageEvent {}

class FilterResaleListByStatus extends ResaleListPageEvent {
  final SaleStatus status;

  FilterResaleListByStatus(this.status);
}

class TapOnResaleListCardButton extends ResaleListPageEvent {
  final ResaleItemModel item;

  TapOnResaleListCardButton(this.item);
}

class SearchFieldChangeResaleListPage extends ResaleListPageEvent {
  final String text;

  SearchFieldChangeResaleListPage(this.text);
}
