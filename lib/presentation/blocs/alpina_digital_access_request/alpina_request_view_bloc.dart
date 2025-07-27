import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/alpina_digital_access_request_models.dart';
import 'package:hr_tcc/domain/usecases/fetch_alpina_digital_access_request_details_usecase.dart';

part 'alpina_request_view_event.dart';
part 'alpina_request_view_state.dart';

class AlpinaRequestViewBloc
    extends Bloc<AlpinaRequestViewEvent, AlpinaRequestViewState> {
  final FetchAlpinaDigitalAccessRequestDetailsUseCase useCase;
  AlpinaRequestViewBloc(this.useCase)
    : super(AlpinaDigitalAccessRequestInitial()) {
    on<LoadAlpinaDigitalAccessRequestDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadAlpinaDigitalAccessRequestDetails event,
    Emitter<AlpinaRequestViewState> emit,
  ) async {
    emit(AlpinaDigitalAccessRequestLoading());
    try {
      final details = await useCase(event.id);
      emit(AlpinaDigitalAccessRequestLoaded(details));
    } on Exception catch (_) {
      emit(AlpinaDigitalAccessRequestError('Ошибка загрузки данных'));
    }
  }
}
