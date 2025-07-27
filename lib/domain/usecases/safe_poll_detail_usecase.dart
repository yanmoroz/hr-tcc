import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/models/models.dart';

class SafePollDetailUseCase {
  final PollQuestionRepository _repository;

  SafePollDetailUseCase(this._repository);

  Future<void> call({required String pollId, required List<PollAnswerAbstractModel> answers}) async {
    return await _repository.sendPollAnswers(pollId, answers);
  }
}
