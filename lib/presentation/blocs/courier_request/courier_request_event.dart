part of 'courier_request_bloc.dart';

abstract class CourierRequestEvent {}

class CourierRequestLoadData extends CourierRequestEvent {}

class CourierRequestDeliveryTypeChanged extends CourierRequestEvent {
  final CourierDeliveryType deliveryType;
  CourierRequestDeliveryTypeChanged(this.deliveryType);
}

class CourierRequestFieldChanged extends CourierRequestEvent {
  final CourierRequestField field;
  final dynamic value;
  CourierRequestFieldChanged(this.field, this.value);
}

class CourierRequestDropdownChanged extends CourierRequestEvent {
  final CourierRequestField field;
  final dynamic value;
  CourierRequestDropdownChanged(this.field, this.value);
}

class CourierRequestSubmit extends CourierRequestEvent {}

class CourierRequestFieldBlurred extends CourierRequestEvent {
  final CourierRequestField field;
  CourierRequestFieldBlurred(this.field);
}
