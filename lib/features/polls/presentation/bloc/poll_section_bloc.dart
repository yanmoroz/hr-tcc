import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_polls.dart';
import '../../domain/entities/poll.dart';

part 'poll_section_event.dart';
part 'poll_section_state.dart';

class PollSectionBloc extends Bloc<PollSectionEvent, PollSectionState> {
  final GetPolls getPolls;

  PollSectionBloc(this.getPolls) : super(PollSectionInitial()) {
    on<LoadPolls>((event, emit) async {
      emit(PollSectionLoading());
      try {
        final polls = await getPolls();
        emit(PollSectionLoaded(polls));
      } catch (_) {
        emit(PollSectionError());
      }
    });
  }
}
