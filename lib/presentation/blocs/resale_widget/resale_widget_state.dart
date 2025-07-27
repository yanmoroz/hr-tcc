part of 'resale_widget_bloc.dart';

// ResaleState
abstract class ResaleWidgetState {
  const ResaleWidgetState();
}

class ResaleWidgetInitial extends ResaleWidgetState {
  const ResaleWidgetInitial();
}

class ResaleWidgetLoading extends ResaleWidgetState {
  const ResaleWidgetLoading();
}

class ResaleWidgetLoaded extends ResaleWidgetState {
  final List<ResaleItemModel> items;
  final String? title;
  final String? subTitle;
  final String? icon;

  const ResaleWidgetLoaded(this.items, {this.title, this.subTitle, this.icon});
}

class ResaleWidgetError extends ResaleWidgetState {
  final String message;

  const ResaleWidgetError(this.message);
}
