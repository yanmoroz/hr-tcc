part of 'address_book_bloc.dart';

sealed class AddressBookEvent {}

class AddressBookStarted extends AddressBookEvent {
  AddressBookStarted();
}

class SearchQueryChanged extends AddressBookEvent {
  SearchQueryChanged(this.query);
  final String query;
}

class LoadNextPage extends AddressBookEvent {
  LoadNextPage();
}