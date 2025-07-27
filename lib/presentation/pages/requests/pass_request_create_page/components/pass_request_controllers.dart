import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/pass_request.dart';
import 'package:hr_tcc/presentation/blocs/pass_request/pass_request_bloc.dart';

class PassRequestControllers {
  final Map<PassRequestField, FocusNode> focusNodes = {
    PassRequestField.type: FocusNode(),
    PassRequestField.purpose: FocusNode(),
    PassRequestField.office: FocusNode(),
    PassRequestField.floor: FocusNode(),
    PassRequestField.date: FocusNode(),
    PassRequestField.timeFrom: FocusNode(),
    PassRequestField.timeTo: FocusNode(),
    PassRequestField.visitors: FocusNode(),
    PassRequestField.otherPurpose: FocusNode(),
  };

  void addBlurListeners(BuildContext context) {
    focusNodes.forEach((field, node) {
      node.addListener(() {
        if (!node.hasFocus) {
          context.read<PassRequestBloc>().add(PassRequestFieldBlurred(field));
        }
      });
    });
  }

  void dispose() {
    for (final node in focusNodes.values) {
      node.dispose();
    }
  }
}
