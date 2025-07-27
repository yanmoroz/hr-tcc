
import 'package:equatable/equatable.dart';

/// Модель сотрудника.
class EmployeeAdressBookModel extends Equatable {
  final int id;
  final String fullName;
  final List<BadgeAdressBook> badges;
  final List<ContactAdressBook> contacts;

  const EmployeeAdressBookModel({
    required this.id,
    required this.fullName,
    required this.badges,
    required this.contacts,
  });

  @override
  List<Object?> get props => [id, fullName, badges, contacts];
}

class BadgeAdressBook extends Equatable {
  final String label;
  const BadgeAdressBook(this.label);

  @override
  List<Object?> get props => [label];
}

class ContactAdressBook extends Equatable {
  final String mainText;
  final String? subText;

  const ContactAdressBook({required this.mainText, this.subText});

  @override
  List<Object?> get props => [mainText, subText];
}