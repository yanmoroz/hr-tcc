import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';

part 'benefits_list_categories_page_event.dart';
part 'benefits_list_categories_page_state.dart';

class BenefitsListCategoriesPageBloc
    extends
        Bloc<BenefitsListCategoriesPageEvent, BenefitsListCategoriesPageState> {
  BenefitsListCategoriesPageBloc()
    : super(BenefitsListCategoriesPageInitial()) {
    on<LoadBenefitsListCategoriesPage>(_onLoadCategoriesPage);
  }

  Future<void> _onLoadCategoriesPage(
    LoadBenefitsListCategoriesPage event,
    Emitter<BenefitsListCategoriesPageState> emit,
  ) async {
    final mockGroups = [
      BenefitsListCategoriesModel(
        category: BenefitCategory.voluntaryHealthInsurance,
        title: 'Добровольное медицинское страхование',
        icon: Assets.icons.benefitsWidget.inshuranceMedWidgetIcon.path,
      ),
      BenefitsListCategoriesModel(
        category: BenefitCategory.financialSupport,
        title: 'Материальная помощь и поддержка',
        icon: Assets.icons.benefitsWidget.materialAssistanceWidgetIcon.path,
      ),
      BenefitsListCategoriesModel(
        category: BenefitCategory.salaryAndBonuses,
        title: 'Оплата труда и премирование',
        icon: Assets.icons.benefitsWidget.primeZoneWidgetIcon.path,
      ),
      BenefitsListCategoriesModel(
        category: BenefitCategory.additionalInsurance,
        title: 'Дополнительное страхование',
        icon: Assets.icons.benefitsWidget.additionalInsuranceWidgetIcon.path,
      ),
      BenefitsListCategoriesModel(
        category: BenefitCategory.discountsAndPromotions,
        title: 'Акции и скидки',
        icon: Assets.icons.benefitsWidget.discountWidgetIcon.path,
      ),
      BenefitsListCategoriesModel(
        category: BenefitCategory.primeZonePlatform,
        title: 'Платформа PrimeZone',
        icon: Assets.icons.benefitsWidget.shopping.path,
      ),
    ];

    emit(BenefitsListCategoriesPageLoaded(model: mockGroups));
  }
}
