import 'package:flutter_bloc/flutter_bloc.dart';

part 'snackbar_state.dart';

class SnackBarCubit extends Cubit<SnackBarState> {
  SnackBarCubit() : super(SnackBarState.initial());

  void showSnackBar(String? message) {
    if (message == null) return;
    emit(SnackBarState.show(message: message));
  }

  void hideSnackBar() {
    emit(SnackBarState.initial());
  }
}
