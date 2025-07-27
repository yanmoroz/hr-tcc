part of 'employee_reward_bloc.dart';

abstract class EmployeeRewardState {}

class EmployeeRewardInitial extends EmployeeRewardState {}

class EmployeeRewardLoadedState extends EmployeeRewardState {
  final EmployeeRewardModel salaryBonusKpiModel;

  EmployeeRewardLoadedState({required this.salaryBonusKpiModel});
}