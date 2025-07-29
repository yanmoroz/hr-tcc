enum PollQuestionType { text, boolean, file }

class PollQuestion {
  final String id;
  final String text;
  final PollQuestionType type;
  final String? answer; // nullable until answered

  const PollQuestion({
    required this.id,
    required this.text,
    required this.type,
    this.answer,
  });
}
