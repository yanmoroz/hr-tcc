import '../repositories/auth_repository.dart';
import '../repositories/current_user_repository.dart';
import '../repositories/pincode_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;
  final PincodeRepository _pincodeRepository;
  final CurrentUserRepository _currentUserRepository;

  LogoutUseCase(
    this._authRepository,
    this._pincodeRepository,
    this._currentUserRepository,
  );

  Future<void> call() async {
    await _authRepository.resetAuthType();
    await _pincodeRepository.updatePincode(null);
    await _currentUserRepository.deleteCurrentUser();
  }
}
