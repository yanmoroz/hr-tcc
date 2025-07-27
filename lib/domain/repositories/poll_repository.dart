import 'package:hr_tcc/domain/models/models.dart';

abstract class PollRepository {
  Future<PollsApiResponse> fetchPolls({
    required int page,
    required int pageSize,
  });
}
