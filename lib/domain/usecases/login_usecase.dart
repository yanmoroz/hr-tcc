import 'package:hr_tcc/domain/repositories/repositories.dart';

import '../core/result.dart';
import '../models/auth_result.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<AuthResult>> call(String username, String password) async {
    return await _repository.login(username, password);
  }
}
