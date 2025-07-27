import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:hr_tcc/domain/models/models.dart';
import 'package:local_auth/local_auth.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cubits/auth/auth_cubit.dart';

part 'pincode_login_event.dart';
part 'pincode_login_state.dart';

class PincodeLoginBloc extends Bloc<PincodeLoginEvent, PincodeLoginState> {
  final VerifyPinUseCase _verifyPinUseCase;
  final LogoutUseCase _logoutUseCase;
  final LocalAuthentication _localAuth;
  final AuthRepository _authRepository;
  final AuthCubit _authCubit;

  PincodeLoginBloc(
    this._verifyPinUseCase,
    this._logoutUseCase,
    this._localAuth,
    this._authRepository,
    this._authCubit,
  ) : super(const PincodeLoginState(authType: AuthType.pincodeOnly)) {
    on<PincodeNumberEnteredOnLoginStep>(_onNumberEntered);
    on<PincodeBackspacePressedOnLoginStep>(_onBackspacePressed);
    on<BiometricAuthRequested>(_onBiometricAuthRequested);
    on<InitializeBiometrics>(_onInitializeBiometrics);
    on<AuthenticateWithBiometricsOnPinStep>(_onAuthenticateWithBiometrics);
    on<VerifyPincode>(_onVerifyPincode);
    on<ResetPincode>(_onResetPincode);

    add(const InitializeBiometrics());
  }

  Future<void> _onInitializeBiometrics(
    InitializeBiometrics event,
    Emitter<PincodeLoginState> emit,
  ) async {
    final authType = await _authRepository.getAuthType();
    emit(state.copyWith(authType: authType ?? AuthType.pincodeOnly));

    if (authType != null && authType != AuthType.pincodeOnly) {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        emit(
          state.copyWith(
            isBiometricAvailable: false,
            isFaceIdAvailable: false,
            isTouchIdAvailable: false,
          ),
        );
        return;
      }

      final biometrics = await _localAuth.getAvailableBiometrics();
      if (biometrics.isEmpty) {
        emit(
          state.copyWith(
            isBiometricAvailable: false,
            isFaceIdAvailable: false,
            isTouchIdAvailable: false,
          ),
        );
        return;
      }

      final hasFaceId = biometrics.contains(BiometricType.face);
      final hasTouchId =
          biometrics.contains(BiometricType.fingerprint) ||
          biometrics.contains(BiometricType.strong);

      emit(
        state.copyWith(
          isBiometricAvailable: true,
          isFaceIdAvailable:
              hasFaceId && authType == AuthType.pincodeWithFaceID,
          isTouchIdAvailable:
              hasTouchId && authType == AuthType.pincodeWithTouchID,
        ),
      );

      if ((authType == AuthType.pincodeWithFaceID && hasFaceId) ||
          (authType == AuthType.pincodeWithTouchID && hasTouchId)) {
        add(BiometricAuthRequested());
      }
    }
  }

  Future<void> _onBiometricAuthRequested(
    BiometricAuthRequested event,
    Emitter<PincodeLoginState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Подтвердите вход в приложение',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        await Future.delayed(const Duration(seconds: 1));
        _authCubit.setStatus(AuthStatus.authenticated);
        if (!isClosed) {
          emit(
            state.copyWith(
              isLoading: false,
              currentPincode: '0000',
              isAuthenticated: true,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Ошибка биометрической аутентификации',
            isAuthenticated: false,
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
          isAuthenticated: false,
        ),
      );
    }
  }

  Future<void> _onAuthenticateWithBiometrics(
    AuthenticateWithBiometricsOnPinStep event,
    Emitter<PincodeLoginState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Подтвердите вход в приложение',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        await Future.delayed(const Duration(seconds: 1));
        _authCubit.setStatus(AuthStatus.authenticated);
        if (!isClosed) {
          emit(
            state.copyWith(
              isLoading: false,
              currentPincode: '0000',
              isAuthenticated: true,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Ошибка биометрической аутентификации',
            isAuthenticated: false,
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
          isAuthenticated: false,
        ),
      );
    }
  }

  Future<void> _onVerifyPincode(
    VerifyPincode event,
    Emitter<PincodeLoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    final isValid = await _verifyPinUseCase(event.pincode);
    if (isValid) {
      await Future.delayed(const Duration(seconds: 1));
      _authCubit.setStatus(AuthStatus.authenticated);
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            currentPincode: event.pincode,
            isAuthenticated: true,
          ),
        );
      }
    } else {
      HapticFeedback.heavyImpact();
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Код не подходит, попробуйте снова',
          currentPincode: event.pincode,
          isAuthenticated: false,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 600));
      if (!isClosed) {
        emit(
          state.copyWith(
            currentPincode: '',
            error: state.error,
            isAuthenticated: false,
          ),
        );
      }
    }
  }

  Future<void> _onNumberEntered(
    PincodeNumberEnteredOnLoginStep event,
    Emitter<PincodeLoginState> emit,
  ) async {
    if (state.currentPincode.length >= 4) return;

    String newPin;
    if (state.error != null) {
      newPin = event.number;
      emit(
        PincodeLoginState(
          authType: state.authType,
          isBiometricAvailable: state.isBiometricAvailable,
          isFaceIdAvailable: state.isFaceIdAvailable,
          isTouchIdAvailable: state.isTouchIdAvailable,
        ).copyWith(currentPincode: newPin, error: null, isAuthenticated: false),
      );
    } else {
      newPin = state.currentPincode + event.number;
      emit(state.copyWith(currentPincode: newPin));
    }

    if (newPin.length == 4) {
      add(VerifyPincode(newPin));
    }
  }

  void _onBackspacePressed(
    PincodeBackspacePressedOnLoginStep event,
    Emitter<PincodeLoginState> emit,
  ) {
    if (state.currentPincode.isEmpty) return;
    emit(
      state.copyWith(
        currentPincode: state.currentPincode.substring(
          0,
          state.currentPincode.length - 1,
        ),
        error: state.error,
        isAuthenticated: false,
      ),
    );
  }

  void _onResetPincode(ResetPincode event, Emitter<PincodeLoginState> emit) {
    _logoutUseCase();
    _authCubit.setStatus(AuthStatus.unauthenticated);
  }
}
