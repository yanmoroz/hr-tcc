import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'courier_request_repository.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';

class CourierRequestRepositoryMock implements CourierRequestRepository {
  @override
  Future<List<Office>> fetchOffices() async {
    return [
      Office(id: '1', name: 'Авилон'),
      Office(id: '2', name: 'Око'),
      Office(id: '3', name: 'Город столиц'),
    ];
  }

  @override
  Future<List<Employee>> fetchEmployees() async {
    return [
      Employee(
        id: '1',
        fullName: 'Пронин Роман Сергеевич',
        role: 'Руководитель',
      ),
      Employee(
        id: '2',
        fullName: 'Климов Михаил Максимович',
        role: 'Руководитель',
      ),
      Employee(
        id: '3',
        fullName: 'Румянцев Александр Романович',
        role: 'Руководитель',
      ),
      Employee(
        id: '4',
        fullName: 'Рубцова Есения Вадимовна',
        role: 'Руководитель',
      ),
      Employee(id: '5', fullName: 'Попов Егор Иванович', role: 'Руководитель'),
      Employee(
        id: '6',
        fullName: 'Грачев Артём Маркович',
        role: 'Руководитель',
      ),
      Employee(
        id: '7',
        fullName: 'Семенова Дарья Евгеньевна',
        role: 'Руководитель',
      ),
    ];
  }

  @override
  Future<List<TripGoal>> fetchTripGoals() async {
    return [
      TripGoal(id: '1', name: 'Отвезти и забрать документы'),
      TripGoal(id: '2', name: 'Забрать документы'),
      TripGoal(id: '3', name: 'Отвезти документы'),
    ];
  }

  @override
  Future<CourierRequestDetails> fetchCourierRequestDetails(String id) async {
    // Мок-данные, можно сделать switch по id для разных заявок
    return CourierRequestDetails(
      id: id,
      status: RequestStatus.completed,
      createdAt: DateTime(2025, 2, 21),
      deliveryType: CourierDeliveryType.regions,
      expReason: 'Обоснование выбора услуг экспресс-доставки',
      contentDesc: 'Опись содержимого',
      company: 'АО «ТК «Центр»',
      department: 'Управление по автоматизации и оптимизации процессов',
      contactPhone: '+7 985 999-00-00',
      tripGoal: 'Цель поездки',
      office: 'Авилон',
      manager: 'Пронин Роман Сергеевич',
      companyName: 'АО «Синхро»',
      address:
          'г. Москва, Пресненская набережная, дом 12 (Башня Федерация «Восток»), этаж. 36, помещение 1/36',
      fio: 'Гребенников Владимир Александрович',
      phone: '+7 985 999-00-00',
      email: 'vladimir.grebennikov@tccenter.ru',
      comment: 'Комментарий',
      priority: 'Обычный приоритет',
      deadline: DateTime(2025, 5, 4),
    );
  }
}
