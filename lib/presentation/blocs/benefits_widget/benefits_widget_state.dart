part of 'benefits_widget_bloc.dart';

abstract class BenefitsWidgetState {
  const BenefitsWidgetState();
}

class BenefitsWidgetInitial extends BenefitsWidgetState {
  const BenefitsWidgetInitial();
}

class BenefitsWidgetLoading extends BenefitsWidgetState {
  const BenefitsWidgetLoading();
}

class BenefitsWidgetLoaded extends BenefitsWidgetState {
  final List<BenefitsItemModel> items;

  const BenefitsWidgetLoaded(this.items);
}

class BenefitsWidgetError extends BenefitsWidgetState {
  final String message;

  const BenefitsWidgetError(this.message);
}
