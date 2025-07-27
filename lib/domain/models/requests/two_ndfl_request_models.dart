import 'package:flutter/material.dart';

enum TwoNdflPurpose { taxDeductions, visa, credit, guardianship }

extension TwoNdflPurposeExt on TwoNdflPurpose {
  String get label {
    switch (this) {
      case TwoNdflPurpose.taxDeductions:
        return 'Получение налоговых вычетов';
      case TwoNdflPurpose.visa:
        return 'Получении визы в консульстве';
      case TwoNdflPurpose.credit:
        return 'Оформление кредита';
      case TwoNdflPurpose.guardianship:
        return 'Оформление опекунства';
    }
  }
}

class TwoNdflRequestDetails {
  final String id;
  final DateTime createdAt;
  final TwoNdflPurpose purpose;
  final DateTimeRange period;

  TwoNdflRequestDetails({
    required this.id,
    required this.createdAt,
    required this.purpose,
    required this.period,
  });
}