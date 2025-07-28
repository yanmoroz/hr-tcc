import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/models/models.dart';

part 'poll_detail_event.dart';
part 'poll_detail_state.dart';

class PollDetailBloc extends Bloc<PollDetailEvent, PollDetailState> {
  final FetchPollDetailUseCase fetchUseCase;
  final SafePollDetailUseCase safeUseCase;

  PollDetailBloc(this.fetchUseCase, this.safeUseCase)
    : super(PollDetailLoading()) {
    on<PollDetailStarted>(_onStarted);
    on<PollDetailAnswerChanged>(_onAnswerChanged);
    on<PollDetailSubmitted>(_onSubmitted);
  }

  Future<void> _onStarted(
    PollDetailStarted event,
    Emitter<PollDetailState> emit,
  ) async {
    emit(PollDetailLoading());
    try {
      final poll = await fetchUseCase(pollId: event.pollId);

      final answers = <String, List<PollAnswerAbstractModel>>{};
      for (final q in poll.questions ?? []) {
        answers[q.id] = _createEmptyAnswersForQuestion(q);
      }

      emit(
        PollDetailLoaded(
          poll: poll,
          answers: answers,
          allRequiredFilled: _checkAllRequired(poll.questions ?? [], answers),
        ),
      );
    } on Object catch (e) {
      emit(PollDetailFailure('Ошибка загрузки: $e'));
    }
  }

  void _onAnswerChanged(
    PollDetailAnswerChanged event,
    Emitter<PollDetailState> emit,
  ) {
    final current = state;
    if (current is! PollDetailLoaded) return;

    final newAnswers = Map<String, List<PollAnswerAbstractModel>>.from(
      current.answers,
    );
    final list = List<PollAnswerAbstractModel>.from(
      newAnswers[event.questionId] ?? [],
    );
    final idx = list.indexWhere((a) => a.type == event.updatedAnswer.type);
    if (idx != -1) {
      list[idx] = event.updatedAnswer;
    } else {
      list.add(event.updatedAnswer);
    }
    newAnswers[event.questionId] = list;

    emit(
      current.copyWith(
        answers: newAnswers,
        allRequiredFilled: _checkAllRequired(
          current.poll.questions ?? [],
          newAnswers,
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    PollDetailSubmitted event,
    Emitter<PollDetailState> emit,
  ) async {
    final current = state;
    if (current is! PollDetailLoaded) return;

    emit(PollDetailSubmitting());
    try {
      await safeUseCase(
        pollId: current.poll.id ?? '',
        answers: current.answers.values.expand((e) => e).toList(),
      );
      emit(PollDetailSuccess());
    } on Object catch (e) {
      emit(PollDetailFailure('Ошибка отправки: $e'));
    }
  }

  // Helpers
  List<PollAnswerAbstractModel> _createEmptyAnswersForQuestion(
    PollQuestionModel q,
  ) {
    return q.types.map((t) {
      switch (t) {
        case PollAnswerType.radioGroup:
          return RadioAnswerModel(questionId: q.id);
        case PollAnswerType.checkboxGroup:
          return CheckboxAnswerModel(questionId: q.id);
        case PollAnswerType.matrixRadio:
          return MatrixRadioAnswerModel(questionId: q.id);
        case PollAnswerType.modalSelector:
          return SelectorAnswerModel(questionId: q.id);
        case PollAnswerType.fileGrid:
          return FileGridAnswerModel(questionId: q.id);
        case PollAnswerType.textField:
          return TextFieldAnswerModel(questionId: q.id);
      }
    }).toList();
  }

  bool _checkAllRequired(
    List<PollQuestionModel> questions,
    Map<String, List<PollAnswerAbstractModel>> answers,
  ) {
    for (final q in questions) {
      final list = answers[q.id];
      if (list == null) return false;

      for (var i = 0; i < q.types.length; i++) {
        if (q.requiredTypes.length > i && q.requiredTypes[i]) {
          final ans = list[i];
          switch (q.types[i]) {
            case PollAnswerType.radioGroup:
              if ((ans as RadioAnswerModel).selectedId == null) return false;
              break;
            case PollAnswerType.checkboxGroup:
              if ((ans as CheckboxAnswerModel).selectedIds.isEmpty) {
                return false;
              }
              break;
            case PollAnswerType.matrixRadio:
              final m = ans as MatrixRadioAnswerModel;
              if (q.rows.isEmpty) return false;
              for (var r = 0; r < q.rows.length; r++) {
                if (!m.values.containsKey(r) ||
                    (m.values[r]?.isEmpty ?? true)) {
                  return false;
                }
              }
              break;
            case PollAnswerType.modalSelector:
              if ((ans as SelectorAnswerModel).selectedId == null) return false;
              break;
            case PollAnswerType.fileGrid:
              if ((ans as FileGridAnswerModel).files.isEmpty) return false;
              break;
            case PollAnswerType.textField:
              if (((ans as TextFieldAnswerModel).text).trim().isEmpty) {
                return false;
              }
              break;
          }
        }
      }
    }
    return true;
  }
}
