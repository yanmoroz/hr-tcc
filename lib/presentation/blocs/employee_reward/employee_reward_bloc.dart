import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/models/models.dart';

part 'employee_reward_event.dart';
part 'employee_reward_state.dart';

class EmployeeRewardBloc
    extends Bloc<EmployeeRewardEvent, EmployeeRewardState> {
  EmployeeRewardBloc() : super(EmployeeRewardInitial()) {
    on<EmployeeRewardLoaded>(_onLoadQuickLinks);
  }

  Future<void> _onLoadQuickLinks(
    EmployeeRewardLoaded event,
    Emitter<EmployeeRewardState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // MOCK
    final salaryBonusKpiData = EmployeeRewardModel(
      salary: '1 234 666 ₽',
      bonus: '117 333 ₽',
      kpiProgress: 0.75,
    );

    emit(EmployeeRewardLoadedState(salaryBonusKpiModel: salaryBonusKpiData));
  }
}
