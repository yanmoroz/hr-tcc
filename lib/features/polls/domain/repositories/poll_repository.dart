import '../entities/poll.dart';
import '../entities/poll_question.dart';

abstract class PollRepository {
  Future<List<Poll>> getPolls();
  Future<Poll> getPollDetail(String pollId);
  Future<void> submitPollAnswers(String pollId, List<PollQuestion> answers);
}
