import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';

part 'benefits_list_category_page_event.dart';
part 'benefits_list_category_page_state.dart';

class BenefitsListCategoryPageBloc
    extends Bloc<BenefitsListCategoryPageEvent, BenefitsListCategoryPageState> {
  final BenefitCategory selectedCategory;

  BenefitsListCategoryPageBloc(this.selectedCategory)
    : super(BenefitsListCategoryPageInitial()) {
    on<LoadBenefitsListCategoryPage>(_onLoadCategoriesPage);
  }

  Future<void> _onLoadCategoriesPage(
    LoadBenefitsListCategoryPage event,
    Emitter<BenefitsListCategoryPageState> emit,
  ) async {
    final mockGroups = getMockGroups(selectedCategory);

    emit(BenefitsListCategoryPageLoaded(model: mockGroups));
  }

  List<BenefitsItemModel> getMockGroups(BenefitCategory selectedCategory) {
    switch (selectedCategory) {
      case BenefitCategory.voluntaryHealthInsurance:
        return [
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
            badgeTitle: 'ДМС',
            title: 'Международный страховой полис',
            subTitle: 'Международный страховой полис',
            expires: 'Бессрочно',
            icon: Assets.icons.benefitsWidget.discountWidgetIcon.path,
          ),
          BenefitsItemModel(
            id: '3',
            badgeTitle: 'ДМС',
            title: 'Страхование сотрудников',
            subTitle: 'ДМС',
            expires: 'Бессрочно',
            icon: Assets.icons.benefitsWidget.discountWidgetIcon.path,
          ),
        ];
      case BenefitCategory.financialSupport:
        return [
          BenefitsItemModel(
            id: '1',
            badgeTitle: 'ДМС',
            title: 'Материальная помощь и поддержка',
            subTitle: 'Материальная помощь и поддержка',
            expires: 'Бессрочно',
            icon: Assets.icons.benefitsWidget.materialAssistanceWidgetIcon.path,
          ),
        ];
      case BenefitCategory.salaryAndBonuses:
        return [
          BenefitsItemModel(
            id: '1',
            badgeTitle: 'ДМС',
            title: 'Оплата труда и премирование',
            subTitle: 'Оплата труда и премирование',
            expires: 'Бессрочно',
            icon: Assets.icons.benefitsWidget.primeZoneWidgetIcon.path,
          ),
        ];
      case BenefitCategory.additionalInsurance:
        return [
          BenefitsItemModel(
            id: '1',
            badgeTitle: 'ДМС',
            title: 'Дополнительное страхование',
            subTitle: 'Дополнительное страхование',
            expires: 'Бессрочно',
            icon:
                Assets.icons.benefitsWidget.additionalInsuranceWidgetIcon.path,
          ),
        ];
      case BenefitCategory.discountsAndPromotions:
        return [
          BenefitsItemModel(
            id: '1',
            badgeTitle: 'ДМС',
            title: 'Акции и скидки',
            subTitle: 'Акции и скидки',
            expires: 'Бессрочно',
            icon: Assets.icons.benefitsWidget.discountWidgetIcon.path,
          ),
        ];
      case BenefitCategory.primeZonePlatform:
        return [
          BenefitsItemModel(
            id: '1',
            badgeTitle: 'ДМС',
            title: 'Платформа PrimeZone',
            subTitle: 'Платформа PrimeZone',
            expires: 'Бессрочно',
            icon: Assets.icons.benefitsWidget.shopping.path,
          ),
        ];
    }
  }
}
