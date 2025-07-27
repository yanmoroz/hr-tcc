import 'package:hr_tcc/domain/models/requests/requests.dart';

abstract class TwoNdflRepository {
  Future<TwoNdflRequestDetails> fetchDetails(String id);
}
