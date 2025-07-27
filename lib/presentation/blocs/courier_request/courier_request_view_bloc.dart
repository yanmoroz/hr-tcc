import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/courier_request_models.dart';
import 'package:hr_tcc/domain/usecases/fetch_courier_request_details_usecase.dart';

part 'courier_request_view_event.dart';
part 'courier_request_view_state.dart';

class CourierRequestViewBloc
    extends Bloc<CourierRequestViewEvent, CourierRequestViewState> {
  final FetchCourierRequestDetailsUseCase useCase;
  CourierRequestViewBloc(this.useCase) : super(CourierRequestDetailsInitial()) {
    on<LoadCourierRequestDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCourierRequestDetails event,
    Emitter<CourierRequestViewState> emit,
  ) async {
    emit(CourierRequestDetailsLoading());
    try {
      final details = await useCase(event.id);
      emit(CourierRequestDetailsLoaded(details));
    } on Exception catch (_) {
      emit(CourierRequestDetailsError('Ошибка загрузки данных'));
    }
  }
}
