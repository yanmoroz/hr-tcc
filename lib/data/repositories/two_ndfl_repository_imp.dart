import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class TwoNdflRepositoryImp implements TwoNdflRepository {
  @override
  Future<TwoNdflRequestDetails> fetchDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TwoNdflRequestDetails(
      id: id,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      purpose: TwoNdflPurpose.taxDeductions,
      period: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 10)),
        end: DateTime.now().subtract(const Duration(days: 5)),
      ),
    );
  }
}
