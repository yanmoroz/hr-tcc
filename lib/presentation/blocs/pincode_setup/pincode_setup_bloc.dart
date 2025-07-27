import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/models.dart';

import '../../../domain/entities/current_user.dart';
import '../../../domain/repositories/access_token_repository.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/current_user_repository.dart';
import '../../../domain/usecases/pincode/update_pincode_usecase.dart';

part 'pincode_setup_event.dart';
part 'pincode_setup_state.dart';

class PincodeSetupBloc extends Bloc<PincodeSetupEvent, PincodeSetupState> {
  final UpdatePincodeUseCase _updatePincodeUseCase;
  final CurrentUserRepository _currentUserRepository;
  final AccessTokenRepository _accessTokenRepository;
  final AuthRepository _authRepository;
  final String _accessToken;
  final CurrentUser _currentUser;

  static const int pinLength = 4;
  String? _firstPin;

  PincodeSetupBloc(
    this._updatePincodeUseCase,
    this._currentUserRepository,
    this._accessTokenRepository,
    this._authRepository,
    this._accessToken,
    this._currentUser,
  ) : super(const PincodeSetupState.initial()) {
    on<PincodeNumberEntered>(_onPincodeNumberEntered);
    on<PincodeBackspacePressedOnSetupStep>(_onPincodeBackspacePressed);
    on<ClearPincode>(_onClearPincode);
  }

  Future<void> _onPincodeNumberEntered(
    PincodeNumberEntered event,
    Emitter<PincodeSetupState> emit,
  ) async {
    // Если это первый ввод цифры после ошибки, очищаем состояние ошибки и начинаем новый ввод
    if (state.error != null) {
      emit(
        const PincodeSetupState.initial(
          isConfirmation: true,
        ).copyWith(currentPincode: event.number),
      );
      return;
    }

    if (state.currentPincode.length >= pinLength) return;

    // Add haptic feedback for number press
    HapticFeedback.selectionClick();

    final newPincode = state.currentPincode + event.number;
    emit(state.copyWith(currentPincode: newPincode));

    if (newPincode.length == pinLength) {
      if (!state.isConfirmation) {
        _firstPin = newPincode;
        // Добавляем задержку перед переходом к экрану подтверждения
        await Future.delayed(const Duration(milliseconds: 200));
        if (!isClosed) {
          emit(const PincodeSetupState.initial(isConfirmation: true));
        }
      } else {
        if (newPincode == _firstPin) {
          await _updatePincodeUseCase(newPincode);
          await _currentUserRepository.updateCurrentUser(_currentUser);
          await _accessTokenRepository.updateAccessToken(_accessToken);
          await _authRepository.updateAuthType(AuthType.pincodeOnly);

          emit(PincodeSetupState.success(newPincode));
        } else {
          // Add error haptic feedback
          HapticFeedback.heavyImpact();
          // Оставляем введенный pincode для анимации цвета
          emit(
            PincodeSetupState.error(
              'Код не совпадает',
              isConfirmation: true,
              currentPincode: newPincode,
            ),
          );

          // Очищаем pincode через 600мс (после завершения анимации цвета)
          await Future.delayed(const Duration(milliseconds: 600));
          if (!isClosed) {
            add(ClearPincode());
          }
        }
      }
    }
  }

  void _onPincodeBackspacePressed(
    PincodeBackspacePressedOnSetupStep event,
    Emitter<PincodeSetupState> emit,
  ) {
    if (state.currentPincode.isNotEmpty) {
      // Add haptic feedback for backspace
      HapticFeedback.selectionClick();

      final newPincode = state.currentPincode.substring(
        0,
        state.currentPincode.length - 1,
      );
      emit(state.copyWith(currentPincode: newPincode));
    }
  }

  void _onClearPincode(ClearPincode event, Emitter<PincodeSetupState> emit) {
    // Сохраняем состояние ошибки, очищая только pincode
    emit(state.copyWith(currentPincode: ''));
  }
}
