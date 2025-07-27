part of 'benefits_list_category_page_bloc.dart';

abstract class BenefitsListCategoryPageState {}

class BenefitsListCategoryPageInitial extends BenefitsListCategoryPageState {}

class BenefitsListCategoryPageLoaded extends BenefitsListCategoryPageState {
  final List<BenefitsItemModel> model;

  BenefitsListCategoryPageLoaded({required this.model});
}
