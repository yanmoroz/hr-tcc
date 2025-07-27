import 'dart:async';

abstract class PincodeRepository {
  Stream<String> get pincodeStream;

  Future<bool> verifyPincode(String pincode);
  Future<void> updatePincode(String? pincode);
  Future<bool> isPincodeSet();
}
