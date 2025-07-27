import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/models/models.dart';

part 'address_book_event.dart';
part 'address_book_state.dart';

class AddressBookBloc extends Bloc<AddressBookEvent, AddressBookState> {
  AddressBookBloc({
    required this.addressBookUseCase,
    required this.addressBookTotalCountUseCase,
    this.pageSize = 10,
  }) : super(
         const AddressBookState(
           employees: [],
           query: '',
           hasReachedMax: false,
           isLoading: false,
           totalCount: 0,
         ),
       ) {
    on<AddressBookStarted>(_onStart);
    on<SearchQueryChanged>(_onSearch);
    on<LoadNextPage>(_onNextPage);
  }

  final FetchAddressBookUseCase addressBookUseCase;
  final FetchAddressBookTotalCountUseCase addressBookTotalCountUseCase;

  final int pageSize;

  int _currentPage = 0;

  Future<void> _onStart(
    AddressBookStarted event,
    Emitter<AddressBookState> emit,
  ) async {
    _currentPage = 0;
    emit(state.copyWith(isLoading: true, hasReachedMax: false));
    final first = await addressBookUseCase(
      page: _currentPage,
      pageSize: pageSize,
      query: state.query,
    );
    final totalCount = await addressBookTotalCountUseCase();

    emit(
      state.copyWith(
        employees: first,
        isLoading: false,
        hasReachedMax: first.length < pageSize,
        totalCount: totalCount,
      ),
    );
  }

  Future<void> _onSearch(
    SearchQueryChanged event,
    Emitter<AddressBookState> emit,
  ) async {
    _currentPage = 0;
    emit(state.copyWith(query: event.query, isLoading: true));
    final fresh = await addressBookUseCase(
      page: _currentPage,
      pageSize: pageSize,
      query: event.query,
    );
    emit(
      state.copyWith(
        employees: fresh,
        isLoading: false,
        hasReachedMax: fresh.length < pageSize,
      ),
    );
  }

  Future<void> _onNextPage(
    LoadNextPage event,
    Emitter<AddressBookState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoading) {
      return; // защита от дублирования
    }
    emit(state.copyWith(isLoading: true));
    _currentPage += 1;
    final next = await addressBookUseCase(
      page: _currentPage,
      pageSize: pageSize,
      query: state.query,
    );

    emit(
      state.copyWith(
        employees: List.of(state.employees)..addAll(next),
        isLoading: false,
        hasReachedMax: next.length < pageSize,
      ),
    );
  }
}
