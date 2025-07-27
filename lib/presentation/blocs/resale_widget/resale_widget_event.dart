part of 'resale_widget_bloc.dart';

abstract class ResaleWidgetEvent {}

class LoadResaleWidgetItems extends ResaleWidgetEvent {}

class ToggleLockResaleWidgetStatus extends ResaleWidgetEvent {
  final String itemId;

  ToggleLockResaleWidgetStatus(this.itemId);
}
