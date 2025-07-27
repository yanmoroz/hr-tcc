class NewsCardModel {
  final int id;
  final String? imageUrl;
  final String time;
  final String title;
  final String subtitle;
  final NewsCategory category;

  final bool notRead;

  NewsCardModel({
    required this.id,
    this.imageUrl,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.category,
    this.notRead = false,
  });
}

enum NewsCategory {
  all('0', 'Все новости'),
  s8News('1', 'S8 новости'),
  s8Business('2', 'S8 бизнес'),
  s8Awards('3', 'S8 награды'),
  s8Events('4', 'S8 мероприятия'),
  s8Clubs('5', 'S8 клубы'),
  s8Academy('6', 'S8 академия'),
  s8Sponsorship('7', 'S8 спонсорство'),
  s8Vacancies('8', 'S8 вакансии'),
  s8Technologies('9', 'S8 технологии'),
  s8Exclusive('10', 'S8 эксклюзив'),
  s8Promo('11', 'S8 акция'),
  s8Helps('12', 'S8 помогает'),
  s8Processes('13', 'S8 процессы');

  const NewsCategory(this.id, this.title);

  final String id;
  final String title;

  static List<String> get titles => NewsCategory.values.map((e) => e.title).toList();

  static NewsCategory fromId(String id) => NewsCategory.values.firstWhere(
    (e) => e.id == id,
    orElse: () => NewsCategory.all,
  );
}
