import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/data/extensions/local_auth_extension.dart';
import 'package:local_auth/local_auth.dart';

import '../../../data/extensions/auth_type_extension.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'biometric_setup_event.dart';
part 'biometric_setup_state.dart';

class BiometricSetupBloc
    extends Bloc<BiometricSetupEvent, BiometricSetupState> {
  final AuthRepository _authRepository;
  final LocalAuthentication _localAuth;
  final BiometricType _type;

  BiometricSetupBloc(this._authRepository, this._localAuth, this._type)
    : super(const BiometricSetupState()) {
    on<CheckBiometricAvailability>(_onCheckBiometricAvailability);
    on<TurnOnBiometric>(_onTurnOnBiometric);
    on<SkipBiometricSetup>(_onSkipBiometricSetup);
  }

  Future<void> _onCheckBiometricAvailability(
    CheckBiometricAvailability event,
    Emitter<BiometricSetupState> emit,
  ) async {
    final isAvailable = await _localAuth.isBiometricAvailable();
    emit(state.copyWith(isAvailable: isAvailable));
  }

  Future<void> _onTurnOnBiometric(
    TurnOnBiometric event,
    Emitter<BiometricSetupState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BiometricSetupStatus.inProgress,
        loadingAction: BiometricSetupAction.biometric,
      ),
    );
    try {
      final isAuthenticated = await _localAuth.authenticateWithBiometrics();
      if (isAuthenticated) {
        await _authRepository.updateAuthType(
          AuthTypeExtension.fromBiometricType(_type),
        );
      }
      emit(
        state.copyWith(
          isAuthenticated: isAuthenticated,
          status:
              isAuthenticated
                  ? BiometricSetupStatus.success
                  : BiometricSetupStatus.failure,
          error: isAuthenticated ? null : 'Ошибка аутентификации',
          loadingAction: BiometricSetupAction.none,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: BiometricSetupStatus.failure,
          error: e.toString(),
          loadingAction: BiometricSetupAction.none,
        ),
      );
    }
  }

  void _onSkipBiometricSetup(
    SkipBiometricSetup event,
    Emitter<BiometricSetupState> emit,
  ) {
    emit(
      state.copyWith(
        status: BiometricSetupStatus.inProgress,
        loadingAction: BiometricSetupAction.skip,
      ),
    );
    emit(
      state.copyWith(
        status: BiometricSetupStatus.skipped,
        loadingAction: BiometricSetupAction.none,
      ),
    );
  }
}
