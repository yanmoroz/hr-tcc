part of 'benefits_list_categories_page_bloc.dart';

abstract class BenefitsListCategoriesPageState {}

class BenefitsListCategoriesPageInitial
    extends BenefitsListCategoriesPageState {}

class BenefitsListCategoriesPageLoaded extends BenefitsListCategoriesPageState {
  final List<BenefitsListCategoriesModel> model;

  BenefitsListCategoriesPageLoaded({required this.model});
}
