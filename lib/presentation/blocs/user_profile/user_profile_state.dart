part of 'user_profile_bloc.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final String name;
  final String photoUrl;
  final String phoneMobile;
  final String phoneWork;
  final String email;
  final String department;
  final String position;
  final String quarterLabel;
  final double kpiProgress;
  final String incomeTotal;
  final String incomeSalary;
  final String incomeBonus;
  final String vacationDays;

  UserProfileLoaded({
    required this.name,
    required this.photoUrl,
    required this.phoneMobile,
    required this.phoneWork,
    required this.email,
    required this.department,
    required this.position,
    required this.quarterLabel,
    required this.kpiProgress,
    required this.incomeTotal,
    required this.incomeSalary,
    required this.incomeBonus,
    required this.vacationDays,
  });
}

class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError(this.message);
}

class UserProfileLoggedOut extends UserProfileState {}
