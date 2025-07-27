import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/presentation/cubits/auth/auth_cubit.dart';

import '../../../domain/core/result.dart';
import '../../../domain/entities/current_user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final AuthCubit _authCubit;

  LoginBloc(this._loginUseCase, this._authCubit) : super(const LoginInitial()) {
    on<LoginWithCredentials>(_onLoginWithCredentials);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<UpdateAgreement>(_onUpdateAgreement);
  }

  Future<void> _onLoginWithCredentials(
    LoginWithCredentials event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isAgreedToTerms) {
      emit(
        LoginError(
          errorMessage:
              'Необходимо согласиться с обработкой персональных данных',
          isPasswordVisible: state.isPasswordVisible,
          isAgreedToTerms: state.isAgreedToTerms,
        ),
      );
      return;
    }

    emit(
      LoginLoading(
        isPasswordVisible: state.isPasswordVisible,
        isAgreedToTerms: state.isAgreedToTerms,
      ),
    );

    try {
      final result = await _loginUseCase(event.username, event.password);
      switch (result) {
        case Success(:final data):
          _authCubit.setStatus(AuthStatus.authenticated);
          emit(
            LoginSuccess(
              accessToken: data.accessToken,
              currentUser: data.currentUser,
            ),
          );
        case Error():
          emit(
            LoginError(
              errorMessage: 'Неверный логин или пароль',
              isPasswordVisible: state.isPasswordVisible,
              isAgreedToTerms: state.isAgreedToTerms,
            ),
          );
      }
    } on Exception {
      emit(
        LoginError(
          errorMessage: 'Произошла ошибка при входе',
          isPasswordVisible: state.isPasswordVisible,
          isAgreedToTerms: state.isAgreedToTerms,
        ),
      );
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    emit(
      LoginInitial(
        isPasswordVisible: !state.isPasswordVisible,
        isAgreedToTerms: state.isAgreedToTerms,
      ),
    );
  }

  void _onUpdateAgreement(UpdateAgreement event, Emitter<LoginState> emit) {
    emit(
      LoginInitial(
        isPasswordVisible: state.isPasswordVisible,
        isAgreedToTerms: event.isAgreed,
      ),
    );
  }
}
