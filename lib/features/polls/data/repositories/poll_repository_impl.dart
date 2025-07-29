import '../../domain/entities/poll.dart';
import '../../domain/entities/poll_question.dart';
import '../../domain/repositories/poll_repository.dart';
import '../datasources/poll_remote_data_source.dart';
import '../models/poll_question_model.dart';

class PollRepositoryImpl implements PollRepository {
  final PollRemoteDataSource remoteDataSource;

  PollRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Poll>> getPolls() => remoteDataSource.fetchPolls();

  @override
  Future<Poll> getPollDetail(String id) => remoteDataSource.fetchPollDetail(id);

  @override
  Future<void> submitPollAnswers(String id, List<PollQuestion> answers) {
    final models =
        answers
            .map(
              (a) => PollQuestionModel(
                id: a.id,
                text: a.text,
                type: a.type,
                answer: a.answer,
              ),
            )
            .toList();
    return remoteDataSource.sendPollAnswers(id, models);
  }
}
