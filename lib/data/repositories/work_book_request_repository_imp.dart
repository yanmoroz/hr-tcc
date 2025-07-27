import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';
import 'package:hr_tcc/domain/entities/requests/requests.dart';

class WorkBookRequestRepositoryImp implements WorkBookRepository {
  @override
  Future<WorkBookRequestDetails> fetchRequestDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return WorkBookRequestDetails(
      id: id,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: RequestStatus.completed,
      purpose: WorkBookPurpose.forRequirement,
      receiveDate: DateTime.now().add(const Duration(days: 5)),
      isCertifiedCopy: true,
      isScanByEmail: true,
    );
  }
}
