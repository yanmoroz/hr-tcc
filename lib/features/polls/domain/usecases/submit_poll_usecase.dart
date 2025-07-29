import '../entities/poll_question.dart';
import '../repositories/poll_repository.dart';

class SubmitPollUseCase {
  final PollRepository repository;

  SubmitPollUseCase(this.repository);

  Future<void> call(String id, List<PollQuestion> answers) =>
      repository.submitPollAnswers(id, answers);
}
