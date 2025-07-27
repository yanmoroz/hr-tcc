part of 'user_kpi_bloc.dart';

abstract class KpiEvent {}

class LoadKpiGroups extends KpiEvent {}

class ChangeKpiGroup extends KpiEvent {
  final int? index;
  
  ChangeKpiGroup(this.index);
}

class ChangeKpiPeriod extends KpiEvent {
  final String period;
  
  ChangeKpiPeriod(this.period);
}