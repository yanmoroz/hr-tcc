part of 'login_bloc.dart';

abstract class LoginState {
  final bool isPasswordVisible;
  final bool isAgreedToTerms;
  final String? errorMessage;

  const LoginState({
    this.isPasswordVisible = false,
    this.isAgreedToTerms = false,
    this.errorMessage,
  });
}

class LoginInitial extends LoginState {
  const LoginInitial({super.isPasswordVisible, super.isAgreedToTerms});
}

class LoginLoading extends LoginState {
  const LoginLoading({super.isPasswordVisible, super.isAgreedToTerms});
}

class LoginSuccess extends LoginState {
  final String accessToken;
  final CurrentUser currentUser;

  const LoginSuccess({required this.accessToken, required this.currentUser});
}

class LoginError extends LoginState {
  const LoginError({
    required String errorMessage,
    super.isPasswordVisible,
    super.isAgreedToTerms,
  }) : super(errorMessage: errorMessage);
}
