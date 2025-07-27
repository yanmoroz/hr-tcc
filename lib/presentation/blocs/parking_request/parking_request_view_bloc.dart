import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/parking_request.dart';
import 'package:hr_tcc/domain/usecases/get_parking_request_by_id_usecase.dart';

part 'parking_request_view_event.dart';
part 'parking_request_view_state.dart';

class ParkingRequestViewBloc
    extends Bloc<ParkingRequestViewEvent, ParkingRequestViewState> {
  final GetParkingRequestByIdUseCase usecase;
  ParkingRequestViewBloc(this.usecase) : super(ParkingRequestViewInitial()) {
    on<LoadParkingRequestDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadParkingRequestDetails event,
    Emitter<ParkingRequestViewState> emit,
  ) async {
    emit(ParkingRequestViewLoading());
    try {
      final details = await usecase(event.id);
      if (details == null) {
        emit(ParkingRequestViewError('Заявка не найдена'));
      } else {
        emit(ParkingRequestViewLoaded(details));
      }
    } on Exception catch (_) {
      emit(ParkingRequestViewError('Ошибка загрузки данных'));
    }
  }
}
