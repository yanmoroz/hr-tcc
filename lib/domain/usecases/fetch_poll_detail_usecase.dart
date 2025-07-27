import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/models/models.dart';

class FetchPollDetailUseCase {
  final PollQuestionRepository _repository;

  FetchPollDetailUseCase(this._repository);

  Future<PollDetailModel> call({required String pollId}) async {
    return await _repository.load(pollId);
  }
}
