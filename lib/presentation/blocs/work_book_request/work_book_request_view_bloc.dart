import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';

part 'work_book_request_view_event.dart';
part 'work_book_request_view_state.dart';

class WorkBookRequestViewBloc
    extends Bloc<WorkBookRequestViewEvent, WorkBookRequestViewState> {
  final FetchWorkBookRequestDetailsUseCase useCase;
  WorkBookRequestViewBloc(this.useCase) : super(WorkBookRequestViewInitial()) {
    on<LoadWorkBookRequestDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadWorkBookRequestDetails event,
    Emitter<WorkBookRequestViewState> emit,
  ) async {
    emit(WorkBookRequestViewLoading());
    try {
      final details = await useCase(event.id);
      emit(WorkBookRequestViewLoaded(details));
    } on Exception catch (_) {
      emit(WorkBookRequestViewError('Ошибка загрузки данных'));
    }
  }

  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
