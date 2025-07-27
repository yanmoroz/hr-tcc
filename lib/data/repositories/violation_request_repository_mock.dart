import 'package:hr_tcc/domain/entities/violation_request.dart';
import 'package:hr_tcc/domain/repositories/violation_request_repository.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:hr_tcc/presentation/widgets/common/app_file_grid/app_file_grid.dart';
import 'dart:math';

class ViolationRequestRepositoryMock implements ViolationRequestRepository {
  static final ViolationRequestRepositoryMock instance =
      ViolationRequestRepositoryMock._internal();
  final List<ViolationRequest> _requests = [];

  ViolationRequestRepositoryMock._internal() {
    if (_requests.isEmpty) {
      _generateMockRequests();
    }
  }
  factory ViolationRequestRepositoryMock() => instance;

  void _generateMockRequests() {
    final random = Random();
    for (int i = 0; i < 10; i++) {
      _requests.add(
        ViolationRequest(
          id: 'violation-$i',
          isConfidential: i % 2 == 0,
          subject: 'Subject $i',
          description: 'Description for violation request $i',
          files: [
            AppFileGridItem(
              name: 'Doc_$i.pdf',
              extension: 'pdf',
              sizeBytes: 1024 * 1024 * (1 + random.nextInt(3)),
              status: AppFileUploadStatus.success,
            ),
          ],
          status:
              RequestStatus.values[(i % (RequestStatus.values.length - 1)) + 1],
          createdAt: DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }
  }

  List<ViolationRequest> get all => List.unmodifiable(_requests);

  void addMockRequests(List<ViolationRequest> requests) {
    _requests.addAll(requests);
  }

  @override
  Future<void> submit(ViolationRequest request) async {
    _requests.add(request);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<ViolationRequest> getById(String id) async {
    final random = Random(id.hashCode);
    return ViolationRequest(
      id: id,
      isConfidential: random.nextBool(),
      subject: 'Subject for $id',
      description: 'Description for violation request $id',
      files: [
        AppFileGridItem(
          name: 'Doc_$id.pdf',
          extension: 'pdf',
          sizeBytes: 1024 * 1024 * (1 + random.nextInt(3)),
          status: AppFileUploadStatus.success,
        ),
      ],
      status:
          RequestStatus
              .values[(random.nextInt(RequestStatus.values.length - 1)) + 1],
      createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
    );
  }
}
