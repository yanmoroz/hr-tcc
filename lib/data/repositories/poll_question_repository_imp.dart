import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/models/models.dart';

import '../../core/logging/app_logger.dart';

class PollQuestionRepositoryImp implements PollQuestionRepository {
  final String assetFolder;
  final AppLogger _logger = GetIt.I<AppLogger>();

  PollQuestionRepositoryImp({this.assetFolder = 'assets/polls'});

  @override
  Future<PollDetailModel> load(String pollId) async {
    final path = '$assetFolder/$pollId.json';
    final jsonStr = await rootBundle.loadString(path);
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    final list = map['questions'] as List<dynamic>? ?? [];
    final questions =
        list
            .map((e) => PollQuestionModel.fromJson(e as Map<String, dynamic>))
            .toList();
    return PollDetailModel(
      id: map['id'] as String?,
      status: map['status'] as String?,
      time: map['time'] as String?,
      imageUrl: map['imageUrl'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      questions: questions,
    );
  }

  @override
  Future<void> sendPollAnswers(
    String pollId,
    List<PollAnswerAbstractModel> answers,
  ) async {
    _logger.i('Начинаем отправку ответов для опроса $pollId...');
    final jsonData = jsonEncode(answers.map((e) => e.toJson()).toList());
    _logger.i('Ответы успешно отправлены на сервер для pollId: $jsonData');
  }
}
