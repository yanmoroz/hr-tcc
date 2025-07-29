import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_polls_usecase.dart';
import '../../viewmodels/poll_card_view_model.dart';

part 'polls_section_event.dart';
part 'polls_section_state.dart';

class PollsSectionBloc extends Bloc<PollsSectionEvent, PollsSectionState> {
  // TODO: ...
  // final FetchPollsListUseCase fetchPollsUseCase;
  final GetPollsUseCase getPollsUseCase;

  PollsSectionBloc(this.getPollsUseCase) : super(Initial()) {
    on<LoadPolls>(_onLoadPolls);
  }

  Future<void> _onLoadPolls(
    LoadPolls event,
    Emitter<PollsSectionState> emit,
  ) async {
    final result = await getPollsUseCase.call(
      page: 1,
      pageSize: 2,
      isCompleted: false,
    );

    emit(
      PollsLoaded(
        polls: result.items.map(PollCardViewModel.fromEntity).toList(),
      ),
    );
  }
}
