part of 'user_profile_bloc.dart';

abstract class UserProfileEvent {}

class LoadUserProfile extends UserProfileEvent {}

class UserProfileLogout extends UserProfileEvent {}
