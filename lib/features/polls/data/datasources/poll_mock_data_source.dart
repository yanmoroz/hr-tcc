import '../../../../core/common/paged_result.dart';
import '../models/poll_model.dart';
import 'poll_remote_data_source.dart';

class PollMockDataSource extends PollRemoteDataSource {
  @override
  Future<PagedResult<PollModel>> fetchPolls({
    required int page,
    required int pageSize,
    required bool? isCompleted,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    List<PollModel> mockPolls = _mockPolls;

    if (isCompleted == null) {
      mockPolls = mockPolls.take(pageSize).toList();
    } else {
      mockPolls =
          mockPolls
              .where((poll) => poll.isCompleted == isCompleted)
              .take(pageSize)
              .toList();
    }

    return PagedResult(
      items: mockPolls,
      totalCount: _mockPolls.length,
      hasMore: false,
    );
  }

  final List<PollModel> _mockPolls = [
    PollModel(
      id: 1,
      title: 'Название опроса-1',
      subtitle: 'Описание опроса-1',
      createdAt: DateTime.now(),
      imageUrl: 'https://placehold.co/600x400@2x.png',
      passedCount: 100,
      isCompleted: false,
    ),
    PollModel(
      id: 2,
      title: 'Название опроса-2',
      createdAt: DateTime.now(),
      subtitle: 'Описание опроса-2',
      imageUrl: 'https://placehold.co/600x400@2x.png',
      passedCount: 100,
      isCompleted: false,
    ),
    PollModel(
      id: 3,
      title: 'Название опроса-3',
      createdAt: DateTime.now(),
      subtitle: 'Описание опроса-3',
      imageUrl: 'https://placehold.co/600x400@2x.png',
      passedCount: 100,
      isCompleted: true,
    ),
    PollModel(
      id: 4,
      title: 'Название опроса-4',
      createdAt: DateTime.now(),
      subtitle: 'Описание опроса-4',
      imageUrl: 'https://placehold.co/600x400@2x.png',
      passedCount: 100,
      isCompleted: true,
    ),
    PollModel(
      id: 5,
      title: 'Название опроса-5',
      createdAt: DateTime.now(),
      subtitle: 'Описание опроса-5',
      imageUrl: 'https://placehold.co/600x400@2x.png',
      passedCount: 100,
      isCompleted: true,
    ),
  ];
}
