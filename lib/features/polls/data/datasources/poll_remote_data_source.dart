import '../models/poll_model.dart';
import '../models/poll_question_model.dart';

abstract class PollRemoteDataSource {
  Future<List<PollModel>> fetchPolls();
  Future<PollModel> fetchPollDetail(String id);
  Future<void> sendPollAnswers(String pollId, List<PollQuestionModel> answers);
}
