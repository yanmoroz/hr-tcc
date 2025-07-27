import 'package:hr_tcc/models/models.dart';

class PollDetailModel {
  final String? id;
  final String? status;
  final String? time;
  final String? imageUrl;
  final String? title;
  final String? description;
  final List<PollQuestionModel>? questions;

  const PollDetailModel({
    this.id,
    this.status,
    this.time,
    this.imageUrl,
    this.title,
    this.description,
    this.questions,
  });
}
