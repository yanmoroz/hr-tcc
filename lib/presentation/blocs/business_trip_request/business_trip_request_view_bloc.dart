import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/domain/entities/requests/business_trip_request.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:hr_tcc/domain/usecases/get_business_trip_request_usecase.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';

part 'business_trip_request_view_event.dart';
part 'business_trip_request_view_state.dart';

class BusinessTripRequestViewBloc
    extends Bloc<BusinessTripRequestViewEvent, BusinessTripRequestViewState> {
  final GetBusinessTripRequestUseCase getRequestUseCase;
  BusinessTripRequestViewBloc(this.getRequestUseCase)
    : super(const BusinessTripRequestViewLoading()) {
    on<LoadBusinessTripRequestDetails>(_onLoadDetails);
  }

  Future<void> _onLoadDetails(
    LoadBusinessTripRequestDetails event,
    Emitter<BusinessTripRequestViewState> emit,
  ) async {
    emit(const BusinessTripRequestViewLoading());
    try {
      final request = await getRequestUseCase(event.id);
      if (request == null) {
        emit(BusinessTripRequestViewLoaded(_mockBusinessTripRequest()));
      } else {
        emit(BusinessTripRequestViewLoaded(request));
      }
    } on Exception catch (e) {
      emit(BusinessTripRequestViewError(e.toString()));
    }
  }
}

BusinessTripRequest _mockBusinessTripRequest() {
  return BusinessTripRequest(
    id: 'mock-id',
    period: DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 3)),
    ),
    fromCity: BusinessTripCity.moscow,
    toCity: BusinessTripCity.spb,
    account: BusinessTripAccount.company,
    purpose: BusinessTripPurpose.other,
    activity: BusinessTripActivity.activity1,
    plannedEvents: 'Планируемые мероприятия',
    coordinatorService: TravelCoordinatorService.required,
    comment: 'Тестовый комментарий',
    participants: [
      Employee(id: '1', fullName: 'Иванов Иван Иванович'),
      Employee(id: '2', fullName: 'Петров Петр Петрович'),
    ],
    status: RequestStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    purposeDescription: 'Тестовое описание цели',
  );
}
