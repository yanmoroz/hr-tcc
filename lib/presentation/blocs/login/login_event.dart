part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class LoginWithCredentials extends LoginEvent {
  final String username;
  final String password;

  const LoginWithCredentials({required this.username, required this.password});
}

class TogglePasswordVisibility extends LoginEvent {
  const TogglePasswordVisibility();
}

class UpdateAgreement extends LoginEvent {
  final bool isAgreed;

  const UpdateAgreement({required this.isAgreed});
}
