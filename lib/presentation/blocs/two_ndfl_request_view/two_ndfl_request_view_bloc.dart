import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_tcc/domain/models/requests/requests.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:flutter/material.dart';

part 'two_ndfl_request_view_event.dart';
part 'two_ndfl_request_view_state.dart';

class TwoNdflRequestViewBloc
    extends Bloc<TwoNdflRequestViewEvent, TwoNdflRequestViewState> {
  final FetchTwoNdflRequestDetailsUseCase fetchDetails;
  TwoNdflRequestViewBloc(this.fetchDetails)
    : super(TwoNdflRequestViewLoading()) {
    on<LoadTwoNdflRequestDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadTwoNdflRequestDetails event,
    Emitter<TwoNdflRequestViewState> emit,
  ) async {
    emit(TwoNdflRequestViewLoading());
    try {
      final details = await fetchDetails(event.requestId);
      emit(TwoNdflRequestViewLoaded(details));
    } on Exception catch (e) {
      emit(TwoNdflRequestViewError('Ошибка загрузки данных: ${e.toString()}'));
    }
  }

  static String formatRange(DateTimeRange range) {
    String format(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
    return '${format(range.start)} — ${format(range.end)}';
  }
}
