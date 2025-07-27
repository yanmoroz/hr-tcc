import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/models/models.dart';

class AdressBookRepositoryImp implements AdressBookRepository {
  @override
  Future<List<EmployeeAdressBookModel>> fetch({
    required int page,
    required int pageSize,
    String query = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 300)); // имитация сети
    final filtered = _all.where(
      (e) =>
          e.fullName.toLowerCase().contains(query.toLowerCase()) ||
          e.badges.any(
            (b) => b.label.toLowerCase().contains(query.toLowerCase()),
          ),
    );
    final start = page * pageSize;
    return filtered.skip(start).take(pageSize).toList();
  }

  @override
  Future<int> totalCount() => Future.value(2208); // Эмуляция поучения количества сотрудников

  final List<EmployeeAdressBookModel> _all = [
    const EmployeeAdressBookModel(
      id: 1,
      fullName: 'Климов Михаил',
      badges: [BadgeAdressBook('Дизайнер'), BadgeAdressBook('Отдел дизайна')],
      contacts: [
        ContactAdressBook(mainText: '+7 985 999‑00‑00', subText: '(моб.)'),
        ContactAdressBook(
          mainText: '+7 985 999‑00‑00, 1234',
          subText: '(раб.)',
        ),
        ContactAdressBook(mainText: 'mikhail.klimov@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 2,
      fullName: 'Иванова Анна',
      badges: [
        BadgeAdressBook('HR‑менеджер'),
        BadgeAdressBook('Отдел персонала'),
      ],
      contacts: [
        ContactAdressBook(mainText: '+7 911 123‑45‑67'),
        ContactAdressBook(mainText: 'anna.ivanova@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 3,
      fullName: 'Петров Сергей',
      badges: [
        BadgeAdressBook('Backend‑разработчик'),
        BadgeAdressBook('ИТ‑отдел'),
      ],
      contacts: [
        ContactAdressBook(mainText: '+7 921 888‑77‑66', subText: '(моб.)'),
        ContactAdressBook(mainText: 'sergey.petrov@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 4,
      fullName: 'Сидоров Алексей',
      badges: [BadgeAdressBook('QA-инженер'), BadgeAdressBook('ИТ-отдел')],
      contacts: [
        ContactAdressBook(mainText: '+7 925 444-55-66', subText: '(моб.)'),
        ContactAdressBook(mainText: 'alexey.sidorov@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 5,
      fullName: 'Смирнова Елена',
      badges: [
        BadgeAdressBook('Маркетолог'),
        BadgeAdressBook('Отдел маркетинга'),
      ],
      contacts: [
        ContactAdressBook(mainText: '+7 915 222-33-44'),
        ContactAdressBook(mainText: 'elena.smirnova@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 6,
      fullName: 'Кузнецов Андрей',
      badges: [
        BadgeAdressBook('Финансовый аналитик'),
        BadgeAdressBook('Финансовый отдел'),
      ],
      contacts: [
        ContactAdressBook(mainText: '+7 916 555-66-77', subText: '(раб.)'),
        ContactAdressBook(mainText: 'andrey.kuznetsov@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 7,
      fullName: 'Васильева Ольга',
      badges: [BadgeAdressBook('Секретарь'), BadgeAdressBook('Администрация')],
      contacts: [
        ContactAdressBook(mainText: '+7 903 333-44-55'),
        ContactAdressBook(mainText: 'olga.vasileva@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 8,
      fullName: 'Васильев Дмитрий',
      badges: [
        BadgeAdressBook('Системный администратор'),
        BadgeAdressBook('ИТ-отдел'),
      ],
      contacts: [
        ContactAdressBook(mainText: '+7 999 777-88-99'),
        ContactAdressBook(mainText: 'dmitry.morozov@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 9,
      fullName: 'Попова Наталья',
      badges: [BadgeAdressBook('Бухгалтер'), BadgeAdressBook('Бухгалтерия')],
      contacts: [
        ContactAdressBook(mainText: '+7 926 111-22-33', subText: '(раб.)'),
        ContactAdressBook(mainText: 'natalia.popova@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 10,
      fullName: 'Егоров Виктор',
      badges: [
        BadgeAdressBook('Менеджер по продажам'),
        BadgeAdressBook('Отдел продаж'),
      ],
      contacts: [
        ContactAdressBook(mainText: '+7 927 444-55-66'),
        ContactAdressBook(mainText: 'victor.egorov@company.ru'),
      ],
    ),
    const EmployeeAdressBookModel(
      id: 11,
      fullName: 'Федорова Мария',
      badges: [
        BadgeAdressBook('UX-дизайнер'),
        BadgeAdressBook('Отдел дизайна'),
      ],
      contacts: [
        ContactAdressBook(mainText: '+7 965 333-22-11'),
        ContactAdressBook(mainText: 'maria.fedorova@company.ru'),
      ],
    ),
  ];
}
