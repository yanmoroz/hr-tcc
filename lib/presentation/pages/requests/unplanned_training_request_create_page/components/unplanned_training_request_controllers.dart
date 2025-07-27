import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/presentation/blocs/unplanned_training_request/unplanned_training_request_bloc.dart';
import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';

class UnplannedTrainingRequestControllers {
  final Map<UnplannedTrainingRequestField, FocusNode> focusNodes = {
    UnplannedTrainingRequestField.eventName: FocusNode(),
    UnplannedTrainingRequestField.organizerName: FocusNode(),
    UnplannedTrainingRequestField.cost: FocusNode(),
    UnplannedTrainingRequestField.goal: FocusNode(),
    UnplannedTrainingRequestField.courseLink: FocusNode(),
  };

  final Map<UnplannedTrainingRequestField, TextEditingController>
  textControllers = {
    UnplannedTrainingRequestField.eventName: TextEditingController(),
    UnplannedTrainingRequestField.organizerName: TextEditingController(),
    UnplannedTrainingRequestField.cost: TextEditingController(),
    UnplannedTrainingRequestField.goal: TextEditingController(),
    UnplannedTrainingRequestField.courseLink: TextEditingController(),
  };

  void addBlurListeners(BuildContext context) {
    focusNodes.forEach((field, node) {
      node.addListener(() {
        if (!node.hasFocus) {
          context.read<UnplannedTrainingRequestBloc>().add(
            UnplannedTrainingFieldBlurred(field),
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
