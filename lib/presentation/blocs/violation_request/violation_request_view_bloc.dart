import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/violation_request.dart';
import 'package:hr_tcc/domain/usecases/get_violation_request_usecase.dart';

part 'violation_request_view_event.dart';
part 'violation_request_view_state.dart';

class ViolationRequestViewBloc
    extends Bloc<ViolationRequestViewEvent, ViolationRequestViewState> {
  final GetViolationRequestUseCase useCase;
  ViolationRequestViewBloc(this.useCase)
    : super(ViolationRequestViewInitial()) {
    on<LoadViolationRequestDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadViolationRequestDetails event,
    Emitter<ViolationRequestViewState> emit,
  ) async {
    emit(ViolationRequestViewLoading());
    try {
      final details = await useCase(event.id);
      emit(ViolationRequestViewLoaded(details));
    } on Exception catch (_) {
      emit(ViolationRequestViewError('Ошибка загрузки данных'));
    }
  }
}
