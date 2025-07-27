part of 'user_navigation_bar_bloc.dart';

abstract class UserNavigationBarState {}

class UserNavigationBarInitial extends UserNavigationBarState {}

class UserNavigationBarLoaded extends UserNavigationBarState {
  final UserNavigationBarModel user;

  UserNavigationBarLoaded({required this.user});
}
