import '../../repositories/pincode_repository.dart';

class VerifyPinUseCase {
  final PincodeRepository _pincodeRepository;

  VerifyPinUseCase(this._pincodeRepository);

  Future<bool> call(String pincode) async {
    return await _pincodeRepository.verifyPincode(pincode);
  }
}
