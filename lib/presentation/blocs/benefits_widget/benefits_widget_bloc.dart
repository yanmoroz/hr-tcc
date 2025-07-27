import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';

part 'benefits_widget_event.dart';
part 'benefits_widget_state.dart';

class BenefitsWidgetBloc
    extends Bloc<BenefitsWidgetEvent, BenefitsWidgetState> {
  BenefitsWidgetBloc() : super(const BenefitsWidgetInitial()) {
    on<LoadBenefitsWidgetItems>(_onLoad);
  }

  Future<void> _onLoad(
    LoadBenefitsWidgetItems event,
    Emitter<BenefitsWidgetState> emit,
  ) async {
    emit(const BenefitsWidgetLoading());

    await Future.delayed(const Duration(milliseconds: 500)); // симуляция API

    final items = [
      BenefitsItemModel(
        id: '1',
        badgeTitle: 'ДМС',
        title: 'Страхование родственников',
        subTitle: 'Полис ДМС для родственников',
        expires: 'Бессрочно',
        icon: Assets.icons.benefitsWidget.inshuranceMedWidgetIcon.path,
      ),
      BenefitsItemModel(
        id: '2',
        badgeTitle: 'Акции и скидки',
        title: 'PrimeAvia для S8 Capital',
        subTitle: 'Корпоративные скидки на авиабилеты',
        expires: 'Бессрочно',
        icon: Assets.icons.benefitsWidget.discountWidgetIcon.path,
      ),
    ];

    emit(BenefitsWidgetLoaded(items));
  }
}
