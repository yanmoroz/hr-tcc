import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/models/requests/work_certificate_request_models.dart';
import 'package:hr_tcc/domain/usecases/fetch_work_certificate_request_details_usecase.dart';

part 'work_certificate_request_view_event.dart';
part 'work_certificate_request_view_state.dart';

class WorkCertificateRequestViewBloc
    extends
        Bloc<WorkCertificateRequestViewEvent, WorkCertificateRequestViewState> {
  final FetchWorkCertificateRequestDetailsUseCase useCase;
  WorkCertificateRequestViewBloc(this.useCase)
    : super(WorkCertificateRequestViewInitial()) {
    on<LoadWorkCertificateRequestDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadWorkCertificateRequestDetails event,
    Emitter<WorkCertificateRequestViewState> emit,
  ) async {
    emit(WorkCertificateRequestViewLoading());
    try {
      final details = await useCase(event.id);
      emit(WorkCertificateRequestViewLoaded(details));
    } on Exception catch (_) {
      emit(WorkCertificateRequestViewError('Ошибка загрузки данных'));
    }
  }
}
