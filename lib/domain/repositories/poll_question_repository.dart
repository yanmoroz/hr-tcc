import 'package:hr_tcc/models/models.dart';

abstract class PollQuestionRepository {
  Future<PollDetailModel> load(String pollId);
  Future<void> sendPollAnswers(
    String pollId,
    List<PollAnswerAbstractModel> answers,
  );
}
