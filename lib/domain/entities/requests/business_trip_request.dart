import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

enum BusinessTripCity { moscow, spb, kazan, ekb, other }

enum BusinessTripAccount { company, self, other }

enum BusinessTripPurpose { purpose1, purpose2, other }

enum BusinessTripActivity { activity1, activity2, other }

enum TravelCoordinatorService { required, notRequired }

class BusinessTripRequest {
  final String id;
  final DateTimeRange period;
  final BusinessTripCity fromCity;
  final BusinessTripCity toCity;
  final BusinessTripAccount account;
  final BusinessTripPurpose purpose;
  final BusinessTripActivity activity;
  final String plannedEvents;
  final TravelCoordinatorService coordinatorService;
  final String? comment;
  final List<Employee> participants;
  final RequestStatus status;
  final DateTime createdAt;
  final String? purposeDescription;

  BusinessTripRequest({
    required this.id,
    required this.period,
    required this.fromCity,
    required this.toCity,
    required this.account,
    required this.purpose,
    required this.activity,
    required this.plannedEvents,
    required this.coordinatorService,
    required this.comment,
    required this.participants,
    required this.status,
    required this.createdAt,
    this.purposeDescription,
  });
}
