class BenefitsListCategoriesModel {
  final BenefitCategory category;
  final String title;
  final String icon;

  const BenefitsListCategoriesModel({
    required this.category,
    required this.title,
    required this.icon,
  });
}

enum BenefitCategory {
  voluntaryHealthInsurance, // Добровольное медицинское страхование
  financialSupport, // Материальная помощь и поддержка
  salaryAndBonuses, // Оплата труда и премирование
  additionalInsurance, // Дополнительное страхование
  discountsAndPromotions, // Акции и скидки
  primeZonePlatform, // Платформа PrimeZone
}

extension BenefitCategorySubTitle on BenefitCategory {
  String get subTitle {
    switch (this) {
      case BenefitCategory.voluntaryHealthInsurance:
        return 'Добровольное медицинское страхование';
      case BenefitCategory.financialSupport:
        return 'Материальная помощь и поддержка';
      case BenefitCategory.salaryAndBonuses:
        return 'Оплата труда и премирование';
      case BenefitCategory.additionalInsurance:
        return 'Дополнительное страхование';
      case BenefitCategory.discountsAndPromotions:
        return 'Акции и скидки';
      case BenefitCategory.primeZonePlatform:
        return 'Платформа PrimeZone';
    }
  }
}