import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_tcc/models/models.dart';

import '../../../core/logging/app_logger.dart';

part 'user_kpi_event.dart';
part 'user_kpi_state.dart';

class UserKpiBloc extends Bloc<KpiEvent, KpiState> {
  final AppLogger _logger = GetIt.I<AppLogger>();

  UserKpiBloc() : super(KpiLoading()) {
    on<LoadKpiGroups>(_onLoad);
    on<ChangeKpiGroup>(_onChangeGroup);
    on<ChangeKpiPeriod>(_onChangePeriod);
  }

  // Моck
  static final kpiPeriodTabs = [
    FilterTabModel(label: 'Квартал', value: null),
    FilterTabModel(label: 'Полугодие', value: null),
    FilterTabModel(label: 'Год', value: null),
  ];

  void _onLoad(LoadKpiGroups event, Emitter<KpiState> emit) {
    final mockGroups = List.generate(3, (i) {
      return KpiPeriodGroup(
        title: '${i + 1} квартал 2025 года',
        subtitle: '1 января – 31 марта',
        progress: 0.55 + i * 0.15,
        planValues: [
          KpiPlanValue(label: 'Средний ФОТ', value: '${1000000 + i * 50000} ₽'),
          KpiPlanValue(
            label: 'Целевая премия',
            value: '${100000 + i * 10000} ₽',
          ),
          KpiPlanValue(label: 'Премия %', value: '${80 + i * 5}%'),
        ],
        kpiCards: [
          KpiCard(
            title: 'Совокупная выручка',
            indicators: [
              KpiIndicator(
                title: '',
                metrics: [KpiMetric(weight: '40', fact: '40', result: '75%')],
              ),
            ],
          ),
          KpiCard(
            title: 'Индивидуальные цели',
            indicators: [
              KpiIndicator(
                title: 'Цель 1',
                metrics: [KpiMetric(weight: '30', fact: '30', result: '80%')],
              ),
              KpiIndicator(
                title: 'Цель 2',
                metrics: [KpiMetric(weight: '20', fact: '22', result: '88%')],
              ),
            ],
          ),
        ],
      );
    });

    emit(KpiLoaded(groups: mockGroups, currentIndex: 0));
  }

  void _onChangeGroup(ChangeKpiGroup event, Emitter<KpiState> emit) {
    final current = state;
    if (current is KpiLoaded) {
      emit(KpiLoaded(groups: current.groups, currentIndex: event.index ?? 0));
    }
  }

  void _onChangePeriod(ChangeKpiPeriod event, Emitter<KpiState> emit) {
    _logger.i('Period changed: ${event.period}');
  }
}
