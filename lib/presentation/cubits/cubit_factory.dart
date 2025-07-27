import 'package:get_it/get_it.dart';

import 'auth/auth_cubit.dart';
import 'snackbar/snackbar_cubit.dart';

class CubitFactory {
  static AuthCubit createAuthCubit() {
    return GetIt.I<AuthCubit>();
  }

  static SnackBarCubit createSnackBarCubit() {
    return GetIt.I<SnackBarCubit>();
  }
}
