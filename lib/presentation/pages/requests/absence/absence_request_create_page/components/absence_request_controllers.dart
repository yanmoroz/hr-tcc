import 'package:flutter/material.dart';

class AbsenceRequestControllers {
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController timeRangeStartController =
      TextEditingController();
  final TextEditingController timeRangeEndController = TextEditingController();

  final FocusNode dateFocus = FocusNode();
  final FocusNode periodFocus = FocusNode();
  final FocusNode timeFocus = FocusNode();
  final FocusNode timeRangeStartFocus = FocusNode();
  final FocusNode timeRangeEndFocus = FocusNode();
  final FocusNode reasonFocus = FocusNode();

  void dispose() {
    reasonController.dispose();
    timeController.dispose();
    timeRangeStartController.dispose();
    timeRangeEndController.dispose();
    dateFocus.dispose();
    periodFocus.dispose();
    timeFocus.dispose();
    timeRangeStartFocus.dispose();
    timeRangeEndFocus.dispose();
    reasonFocus.dispose();
  }
}
