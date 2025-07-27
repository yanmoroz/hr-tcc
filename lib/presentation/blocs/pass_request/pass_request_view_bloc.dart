import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/pass_request.dart';
import 'package:hr_tcc/domain/usecases/get_pass_request_by_id_usecase.dart';

part 'pass_request_view_event.dart';
part 'pass_request_view_state.dart';

class PassRequestViewBloc
    extends Bloc<PassRequestViewEvent, PassRequestViewState> {
  final GetPassRequestByIdUseCase usecase;
  PassRequestViewBloc(this.usecase) : super(PassRequestViewInitial()) {
    on<LoadPassRequestDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadPassRequestDetails event,
    Emitter<PassRequestViewState> emit,
  ) async {
    emit(PassRequestViewLoading());
    try {
      final details = await usecase(event.id);
      if (details == null) {
        emit(PassRequestViewError('Заявка не найдена'));
      } else {
        emit(PassRequestViewLoaded(details));
      }
    } on Exception catch (_) {
      emit(PassRequestViewError('Ошибка загрузки данных'));
    }
  }
}
