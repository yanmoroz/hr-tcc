import 'package:hr_tcc/domain/entities/requests/request_status.dart';

enum CourierDeliveryType { moscow, regions }

class Office {
  final String id;
  final String name;
  Office({required this.id, required this.name});
}

class Employee {
  final String id;
  final String fullName;
  final String role;
  Employee({
    required this.id,
    required this.fullName,
    this.role = 'Руководитель',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'role': role,
  };
}

class TripGoal {
  final String id;
  final String name;
  TripGoal({required this.id, required this.name});
}

enum CourierRequestField {
  company,
  department,
  contactPhone,
  companyName,
  address,
  fio,
  phone,
  email,
  expReason,
  contentDesc,
  comment,
  tripGoal,
  office,
  manager,
  deadline,
  deadlineRange,
  addComment,
  deliveryType,
  priority,
}

class CourierRequestDetails {
  final String id;
  final RequestStatus status;
  final DateTime createdAt;
  final CourierDeliveryType deliveryType;
  final String expReason;
  final String contentDesc;
  final String company;
  final String department;
  final String contactPhone;
  final String tripGoal;
  final String office;
  final String manager;
  final String companyName;
  final String address;
  final String fio;
  final String phone;
  final String email;
  final String comment;
  final String priority;
  final DateTime deadline;

  CourierRequestDetails({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.deliveryType,
    required this.expReason,
    required this.contentDesc,
    required this.company,
    required this.department,
    required this.contactPhone,
    required this.tripGoal,
    required this.office,
    required this.manager,
    required this.companyName,
    required this.address,
    required this.fio,
    required this.phone,
    required this.email,
    required this.comment,
    required this.priority,
    required this.deadline,
  });
}
