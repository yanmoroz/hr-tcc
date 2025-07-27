part of 'auth_cubit.dart';

enum AuthStatus { authenticated, unauthenticated, pincode }

class AuthState {
  final AuthStatus? status;

  AuthState({this.status});
}
