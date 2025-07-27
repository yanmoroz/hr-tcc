part of 'user_kpi_bloc.dart';

abstract class KpiState {}

class KpiLoading extends KpiState {}

class KpiLoaded extends KpiState {
  final List<KpiPeriodGroup> groups;
  final int currentIndex;

  KpiLoaded({required this.groups, required this.currentIndex});
}