import 'package:hr_tcc/domain/models/models.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';

class PollRepositoryImp implements PollRepository {
  @override
  Future<PollsApiResponse> fetchPolls({
    required int page,
    required int pageSize,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (page == 1) {
      return PollsApiResponse.fromJson({
        'not_finished_polls': List.generate(
          4,
          (i) => {
            'id': 100 + i,
            'imageUrl': 'https://placehold.co/600x400@2x.png',
            'timestamp': 'Сегодня в 12:${10 + i}',
            'title': 'Опрос №${i + 1} (не пройден)',
            'subtitle': 'Описание опроса ${i + 1}',
            'passedCount': 0,
          },
        ),
        'not_finished_polls_total_count': '4',
        'finished_polls': List.generate(
          pageSize,
          (i) => {
            'id': i + 1,
            'imageUrl': 'https://placehold.co/600x400@2x.png',
            'timestamp': 'Вчера в 14:${10 + i}',
            'title': 'Опрос №${i + 1} (пройден)',
            'subtitle': 'Описание опроса ${i + 1}',
            'passedCount': 123 + i,
          },
        ),
        'finished_polls_total_count': '10',
      });
    }

    final startId = (page - 1) * pageSize + 1;
    if (startId > 12) return PollsApiResponse.fromJson({});

    return PollsApiResponse.fromJson({
      'finished_polls': List.generate(
        pageSize,
        (i) => {
          'id': startId + i,
          'imageUrl': 'https://placehold.co/600x400@2x.png',
          'timestamp': 'Позавчера в 13:${10 + i}',
          'title': 'Опрос №${startId + i} (пройден)',
          'subtitle': 'Описание опроса ${startId + i}',
          'passedCount': 200 + i,
        },
      ),
    });
  }
}
