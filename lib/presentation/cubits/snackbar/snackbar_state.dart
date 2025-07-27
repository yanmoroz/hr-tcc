part of 'snackbar_cubit.dart';

class SnackBarState {
  final String? message;
  final bool isVisible;

  const SnackBarState({this.message, required this.isVisible});

  factory SnackBarState.initial() => const SnackBarState(isVisible: false);

  factory SnackBarState.show({required String message}) =>
      SnackBarState(message: message, isVisible: true);

  SnackBarState copyWith({String? message, bool? isVisible}) {
    return SnackBarState(
      message: message ?? this.message,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
