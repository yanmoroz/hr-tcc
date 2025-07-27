import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/requests/request_status.dart';
import 'package:hr_tcc/domain/entities/requests/unplanned_training_request.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';
import 'package:hr_tcc/domain/usecases/get_unplanned_training_request_usecase.dart';

part 'unplanned_training_request_view_event.dart';
part 'unplanned_training_request_view_state.dart';

class UnplannedTrainingRequestViewBloc
    extends
        Bloc<
          UnplannedTrainingRequestViewEvent,
          UnplannedTrainingRequestViewState
        > {
  final GetUnplannedTrainingRequestUseCase getRequestUseCase;
  UnplannedTrainingRequestViewBloc(this.getRequestUseCase)
    : super(UnplannedTrainingRequestViewLoading()) {
    on<LoadUnplannedTrainingRequestDetails>(_onLoadDetails);
  }

  Future<void> _onLoadDetails(
    LoadUnplannedTrainingRequestDetails event,
    Emitter<UnplannedTrainingRequestViewState> emit,
  ) async {
    emit(UnplannedTrainingRequestViewLoading());
    try {
      final request = await getRequestUseCase(event.id);
      if (request == null) {
        emit(UnplannedTrainingRequestViewLoaded(_mockRequest()));
      } else {
        emit(UnplannedTrainingRequestViewLoaded(request));
      }
    } on Exception catch (e) {
      emit(UnplannedTrainingRequestViewError(e.toString()));
    }
  }

  UnplannedTrainingRequest _mockRequest() {
    return UnplannedTrainingRequest(
      id: 'mock-id',
      manager: 'Иванов Иван',
      approver: 'Петров Петр',
      organizer: UnplannedTrainingOrganizer.org1,
      organizerName: null,
      eventName: 'Мастер-класс по Flutter',
      type: UnplannedTrainingType.seminar,
      form: UnplannedTrainingForm.online,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 2)),
      unknownDates: false,
      month: null,
      cost: '15000',
      goal: 'Улучшить навыки мобильной разработки',
      courseLink: 'https://example.com',
      employees: [
        Employee(id: '1', fullName: 'Сидоров Сидор', role: 'Разработчик'),
        Employee(id: '2', fullName: 'Мария Иванова', role: 'Тестировщик'),
      ],
      status: RequestStatus.newRequest,
      createdAt: DateTime.now(),
    );
  }
}
