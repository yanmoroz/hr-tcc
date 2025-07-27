import '../../domain/entities/poll.dart';

class PollModel extends Poll {
  PollModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.hasVoted,
  });

  factory PollModel.fromJson(Map<String, dynamic> json) => PollModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    startDate: DateTime.parse(json['start_date'] as String),
    endDate: DateTime.parse(json['end_date'] as String),
    hasVoted: json['has_voted'] as bool,
  );
}
