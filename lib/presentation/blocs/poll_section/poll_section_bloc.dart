import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/models/models.dart';

part 'poll_section_event.dart';
part 'poll_section_state.dart';

class PollSectionBloc extends Bloc<PollSectionEvent, PollSectionState> {
  final FetchPollsListUseCase fetchPollsUseCase;

  PollSectionBloc(this.fetchPollsUseCase) : super(PollSectionInitial()) {
    on<LoadPolls>(_onLoadPolls);
  }

  Future<void> _onLoadPolls(
    LoadPolls event,
    Emitter<PollSectionState> emit,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // эмуляция загрузки

    final polls = [
      PollCardModel(
        id: 1,
        imageUrl: 'https://placehold.co/600x400@2x.png',
        timestamp: 'Вчера в 21:08',
        title: 'Нам важно ваше мнение — участвуйте в выборе добрых дел',
        subtitle: '«Свет в сердцах»: развитие волонтёрства в S8 Capital',
        passedCount: 557,
        status: PollStatus.notPassed,
      ),
      PollCardModel(
        id: 2,
        imageUrl: 'https://placehold.co/600x400@2x.png',
        timestamp: 'Вчера в 21:08',
        title: 'Нам важно ваше мнение — участвуйте в выборе добрых дел',
        subtitle: '«Свет в сердцах»: развитие волонтёрства в S8 Capital',
        passedCount: 157,
        status: PollStatus.passed,
      ),
      PollCardModel(
        id: 3,
        imageUrl: 'https://placehold.co/600x400@2x.png',
        timestamp: 'Вчера в 21:08',
        title: 'Нам важно ваше мнение — участвуйте в выборе добрых дел',
        subtitle: '«Свет в сердцах»: развитие волонтёрства в S8 Capital',
        passedCount: 157,
        status: PollStatus.notPassed,
      ),
    ];
    emit(PollSectionLoaded(polls: polls));
  }
}
