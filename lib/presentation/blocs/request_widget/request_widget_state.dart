part of 'request_widget_bloc.dart';

class RequestsWidgetState {
  final bool isLoading;
  final List<RequestWidgetItemModel> items;

  const RequestsWidgetState({required this.isLoading, required this.items});

  factory RequestsWidgetState.initial() =>
      const RequestsWidgetState(isLoading: false, items: []);

  RequestsWidgetState copyWith({
    bool? isLoading,
    List<RequestWidgetItemModel>? items,
    String? navigateTo,
  }) {
    return RequestsWidgetState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
    );
  }
}