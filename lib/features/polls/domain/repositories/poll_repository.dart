import '../entities/poll.dart';

abstract class PollRepository {
  Future<List<Poll>> fetchPolls();
}
