import 'package:intl/intl.dart';

// Класс для склонения слов

final NumberFormat _numberFormatter = NumberFormat('#,###', 'ru');

String getEmployeesText(int count) {
  final formattedCount = _numberFormatter.format(count);
  return Intl.plural(
    count,
    zero: 'Нет сотрудников',
    one: '$formattedCount сотрудник',
    few: '$formattedCount сотрудника',
    many: '$formattedCount сотрудников',
    other: '$formattedCount сотрудников',
    name: 'getEmployeesText',
    args: [count],
    locale: Intl.getCurrentLocale(),
  );
}

String getViolationsText(int count) {
  final formattedCount = _numberFormatter.format(count);
  return Intl.plural(
    count,
    zero: 'Нет заявок',
    one: '$formattedCount заявка',
    few: '$formattedCount заявки',
    many: '$formattedCount заявок',
    other: '$formattedCount заявок',
    name: 'getViolationsText',
    args: [count],
    locale: Intl.getCurrentLocale(),
  );
}

String getResaleText(int count) {
  final formattedCount = _numberFormatter.format(count);
  return Intl.plural(
    count,
    one: '$formattedCount товар',
    few: '$formattedCount товара',
    many: '$formattedCount товаров',
    other: '$formattedCount товаров',
    name: 'getResaleText',
    args: [count],
    locale: Intl.getCurrentLocale(),
  );
}

String getPollsText(int count) {
  final formattedCount = _numberFormatter.format(count);
  return Intl.plural(
    count,
    one: '$formattedCount не пройден',
    few: '$formattedCount не пройдены',
    many: '$formattedCount не пройдены',
    other: '$formattedCount не пройдены',
    name: 'getPollsText',
    args: [count],
    locale: Intl.getCurrentLocale(),
  );
}

String getStaffText(int count) {
  final formattedCount = _numberFormatter.format(count);
  return Intl.plural(
    count,
    one: '$formattedCount сотрудник',
    few: '$formattedCount сотрудника',
    many: '$formattedCount сотрудников',
    other: '$formattedCount сотрудников',
    name: 'getStaffText',
    args: [count],
    locale: Intl.getCurrentLocale(),
  );
}

String getNewsText(int count) {
  final formattedCount = _numberFormatter.format(count);
  return Intl.plural(
    count,
    one: '$formattedCount новая',
    few: '$formattedCount новые',
    many: '$formattedCount новых',
    other: '$formattedCount новых',
    name: 'getNewsText',
    args: [count],
    locale: Intl.getCurrentLocale(),
  );
}

String commentsIntl(int count) {
  return Intl.plural(
    count,
    zero: '$count комментариев',
    one: '$count комментарий',
    few: '$count комментария',
    many: '$count комментариев',
    other: '$count комментариев',
    // укажи локаль, если нужно явно
    locale: 'ru',
  );
}