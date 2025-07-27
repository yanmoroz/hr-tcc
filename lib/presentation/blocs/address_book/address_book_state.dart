part of 'address_book_bloc.dart';

class AddressBookState extends Equatable {
  const AddressBookState({
    required this.employees,
    required this.query,
    required this.hasReachedMax,
    required this.isLoading,
    required this.totalCount,
  });

  final List<EmployeeAdressBookModel> employees;
  final String query;
  final bool hasReachedMax;
  final bool isLoading; // флаг загрузки следующей страницы
  final int totalCount;

  AddressBookState copyWith({
    List<EmployeeAdressBookModel>? employees,
    String? query,
    bool? hasReachedMax,
    bool? isLoading,
    int? totalCount,
  }) {
    return AddressBookState(
      employees: employees ?? this.employees,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoading: isLoading ?? this.isLoading,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [employees, query, hasReachedMax, isLoading];
}