import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final PincodeRepository _pincodeRepository;

  AuthCubit(this._authRepository, this._pincodeRepository)
    : super(AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final authType = await _authRepository.getAuthType();
    final isPincodeSet = await _pincodeRepository.isPincodeSet();

    _pincodeRepository.pincodeStream.listen((pincode) {
      if (pincode.isNotEmpty) {
        setStatus(AuthStatus.pincode);
      }
    });

    if (isPincodeSet) {
      setStatus(AuthStatus.pincode);
    } else {
      if (authType == null) {
        setStatus(AuthStatus.unauthenticated);
      } else {
        setStatus(AuthStatus.authenticated);
      }
    }
  }

  void setStatus(AuthStatus status) {
    emit(AuthState(status: status));
  }
}
