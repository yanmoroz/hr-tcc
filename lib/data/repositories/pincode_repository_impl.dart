import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

import '../../core/constants/app_constants.dart';

class PincodeRepositoryImpl implements PincodeRepository {
  final FlutterSecureStorage _storage;

  PincodeRepositoryImpl(this._storage);

  final StreamController<String> _pincodeStreamController =
      StreamController<String>.broadcast();

  @override
  Stream<String> get pincodeStream => _pincodeStreamController.stream;

  @override
  Future<bool> verifyPincode(String pincode) async {
    final storedPincode = await _storage.read(key: AppConstants.pincodeKey);
    return storedPincode == pincode;
  }

  @override
  Future<void> updatePincode(String? pincode) async {
    if (pincode == null) {
      await _storage.delete(key: AppConstants.pincodeKey);
    } else {
      await _storage.write(key: AppConstants.pincodeKey, value: pincode);
    }
  }

  @override
  Future<bool> isPincodeSet() async {
    final pincode = await _storage.read(key: AppConstants.pincodeKey);
    return pincode != null && pincode.isNotEmpty;
  }

  void dispose() {
    _pincodeStreamController.close();
  }
}
