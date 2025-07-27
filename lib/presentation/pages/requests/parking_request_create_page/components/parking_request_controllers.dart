import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/parking_request.dart';
import 'package:hr_tcc/presentation/blocs/parking_request/parking_request_bloc.dart';

class ParkingRequestControllers {
  final Map<ParkingRequestField, FocusNode> focusNodes = {
    ParkingRequestField.type: FocusNode(),
    ParkingRequestField.purpose: FocusNode(),
    ParkingRequestField.office: FocusNode(),
    ParkingRequestField.floor: FocusNode(),
    ParkingRequestField.date: FocusNode(),
    ParkingRequestField.timeFrom: FocusNode(),
    ParkingRequestField.timeTo: FocusNode(),
    ParkingRequestField.visitors: FocusNode(),
    ParkingRequestField.carBrand: FocusNode(),
    ParkingRequestField.carNumber: FocusNode(),
    ParkingRequestField.purposeText: FocusNode(),
    ParkingRequestField.cargoReason: FocusNode(),
    ParkingRequestField.cargoDescription: FocusNode(),
    ParkingRequestField.driver: FocusNode(),
    ParkingRequestField.escort: FocusNode(),
    ParkingRequestField.parkingPlaceNumber: FocusNode(),
    ParkingRequestField.liftAction: FocusNode(),
  };

  final Map<ParkingRequestField, TextEditingController> textControllers = {
    ParkingRequestField.purposeText: TextEditingController(),
    ParkingRequestField.cargoReason: TextEditingController(),
    ParkingRequestField.cargoDescription: TextEditingController(),
    ParkingRequestField.driver: TextEditingController(),
    ParkingRequestField.escort: TextEditingController(),
    ParkingRequestField.parkingPlaceNumber: TextEditingController(),
    ParkingRequestField.carNumber: TextEditingController(),
  };

  void addBlurListeners(BuildContext context) {
    focusNodes.forEach((field, node) {
      node.addListener(() {
        if (!node.hasFocus) {
          context.read<ParkingRequestBloc>().add(
            ParkingRequestFieldBlurred(field),
          );
        }
      });
    });
  }

  void dispose() {
    for (final node in focusNodes.values) {
      node.dispose();
    }
    for (final controller in textControllers.values) {
      controller.dispose();
    }
  }
}
