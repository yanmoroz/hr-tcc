import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/usecases/get_referral_program_request_by_id_usecase.dart';
import 'package:hr_tcc/domain/entities/requests/referral_program_request.dart';

part 'referral_program_request_view_event.dart';
part 'referral_program_request_view_state.dart';

class ReferralProgramRequestViewBloc
    extends
        Bloc<ReferralProgramRequestViewEvent, ReferralProgramRequestViewState> {
  final GetReferralProgramRequestByIdUseCase getRequestByIdUseCase;

  ReferralProgramRequestViewBloc(this.getRequestByIdUseCase)
    : super(const ReferralProgramRequestViewState(isLoading: false)) {
    on<LoadReferralProgramRequest>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final request = await getRequestByIdUseCase(event.id);
        if (request == null) {
          emit(state.copyWith(isLoading: false, error: 'Заявка не найдена'));
        } else {
          emit(state.copyWith(isLoading: false, request: request));
        }
      } on Exception catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}
