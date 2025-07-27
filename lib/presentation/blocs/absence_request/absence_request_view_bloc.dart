import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/requests/absence_request.dart';
import 'package:hr_tcc/domain/usecases/get_absence_request_usecase.dart';

part 'absence_request_view_event.dart';
part 'absence_request_view_state.dart';

class AbsenceRequestViewBloc
    extends Bloc<AbsenceRequestViewEvent, AbsenceRequestViewState> {
  final GetAbsenceRequestUseCase getUseCase;
  AbsenceRequestViewBloc(this.getUseCase) : super(AbsenceRequestViewInitial()) {
    on<LoadAbsenceRequestDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadAbsenceRequestDetails event,
    Emitter<AbsenceRequestViewState> emit,
  ) async {
    emit(AbsenceRequestViewLoading());
    try {
      final details = await getUseCase(event.id);
      emit(AbsenceRequestViewLoaded(details));
    } on Exception catch (_) {
      emit(AbsenceRequestViewError('Ошибка загрузки данных'));
    }
  }
}
