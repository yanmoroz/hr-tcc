import '../../repositories/repositories.dart';

class UpdatePincodeUseCase {
  final PincodeRepository _pincodeRepository;

  UpdatePincodeUseCase(this._pincodeRepository);

  Future<void> call(String pincode) async {
    await _pincodeRepository.updatePincode(pincode);
  }
}
