enum RequestStatus {
  all,
  active,
  newRequest,
  draft,
  completed,
  approved,
  rejected,
}

extension RequestStatusExtension on RequestStatus {
  String get name {
    switch (this) {
      case RequestStatus.all:
        return 'Все статусы';
      case RequestStatus.active:
        return 'Активно';
      case RequestStatus.newRequest:
        return 'Новые';
      case RequestStatus.draft:
        return 'Черновики';
      case RequestStatus.completed:
        return 'Выполнено';
      case RequestStatus.approved:
        return 'Согласовано';
      case RequestStatus.rejected:
        return 'Отказ';
    }
  }
}
