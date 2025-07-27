import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

// Справочники

enum UnplannedTrainingOrganizer {
  org1('ООО "Нетология"'),
  org2('ООО "КОРПСКИЛЗ"'),
  org3('Ассоциация ДПО "Русская школа управления"'),
  org4('АНО ДПО "СофтЛайн Эдюкейшн"'),
  org5('Учебный Центр "Специалист"'),
  org6('ООО "СКИЛЛФАКТОРИ"'),
  other('Организатор не в списке');

  final String label;
  const UnplannedTrainingOrganizer(this.label);
}

enum UnplannedTrainingType {
  seminar('Семинар'),
  course('Курс'),
  training('Тренинг'),
  other('Другое');

  final String label;
  const UnplannedTrainingType(this.label);
}

enum UnplannedTrainingForm {
  online('Онлайн'),
  offline('Офлайн'),
  mixed('Смешанная');

  final String label;
  const UnplannedTrainingForm(this.label);
}

// Enum для полей формы

enum UnplannedTrainingRequestField {
  manager,
  approver,
  organizer,
  organizerName,
  eventName,
  type,
  form,
  startDate,
  endDate,
  unknownDates,
  month,
  cost,
  goal,
  courseLink,
  employees,
}

enum UnplannedTrainingMonth {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

extension UnplannedTrainingMonthExt on UnplannedTrainingMonth {
  String get label {
    switch (this) {
      case UnplannedTrainingMonth.january:
        return 'Январь';
      case UnplannedTrainingMonth.february:
        return 'Февраль';
      case UnplannedTrainingMonth.march:
        return 'Март';
      case UnplannedTrainingMonth.april:
        return 'Апрель';
      case UnplannedTrainingMonth.may:
        return 'Май';
      case UnplannedTrainingMonth.june:
        return 'Июнь';
      case UnplannedTrainingMonth.july:
        return 'Июль';
      case UnplannedTrainingMonth.august:
        return 'Август';
      case UnplannedTrainingMonth.september:
        return 'Сентябрь';
      case UnplannedTrainingMonth.october:
        return 'Октябрь';
      case UnplannedTrainingMonth.november:
        return 'Ноябрь';
      case UnplannedTrainingMonth.december:
        return 'Декабрь';
    }
  }
}

class UnplannedTrainingRequest {
  final String id;
  final String manager;
  final String approver;
  final UnplannedTrainingOrganizer organizer;
  final String? organizerName;
  final String eventName;
  final UnplannedTrainingType type;
  final UnplannedTrainingForm form;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool unknownDates;
  final UnplannedTrainingMonth? month;
  final String cost;
  final String goal;
  final String? courseLink;

  final List<Employee> employees;
  final RequestStatus status;
  final DateTime createdAt;

  UnplannedTrainingRequest({
    required this.id,
    required this.manager,
    required this.approver,
    required this.organizer,
    this.organizerName,
    required this.eventName,
    required this.type,
    required this.form,
    this.startDate,
    this.endDate,
    required this.unknownDates,
    this.month,
    required this.cost,
    required this.goal,
    this.courseLink,
    required this.employees,
    required this.status,
    required this.createdAt,
  });
}
