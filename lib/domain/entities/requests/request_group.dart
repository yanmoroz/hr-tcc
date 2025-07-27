enum RequestGroup { all, education, office, corporate, hr, regime }

extension RequestGroupExtension on RequestGroup {
  String get name {
    switch (this) {
      case RequestGroup.all:
        return 'Все';
      case RequestGroup.education:
        return 'Обучение';
      case RequestGroup.office:
        return 'Эксплуатация и обеспечение офиса';
      case RequestGroup.corporate:
        return 'Корпоративные сервисы';
      case RequestGroup.hr:
        return 'HR-сервисы';
      case RequestGroup.regime:
        return 'Управление режима';
    }
  }
}
