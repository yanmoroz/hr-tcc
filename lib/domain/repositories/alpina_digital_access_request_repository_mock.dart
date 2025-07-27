import 'alpina_digital_access_request_repository.dart';
import '../models/requests/alpina_digital_access_request_models.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';

class AlpinaDigitalAccessRequestRepositoryMock
    implements AlpinaDigitalAccessRequestRepository {
  @override
  Future<AlpinaDigitalAccessRequest> fetchRequestDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AlpinaDigitalAccessRequest(
      id: id,
      fio: 'Иванов Иван',
      email: 'ivanov@alpina.ru',
      department: 'ИТ',
      position: 'Разработчик',
      accessLevel: 'Чтение',
      justification: 'Для работы с проектом',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: RequestStatus.active,
      date: DateTime.now().add(const Duration(days: 100)),
      wasAccessProvided: true,
      comment: 'Текст комментария',
      isChecked: true,
    );
  }
}
