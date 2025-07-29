class Poll {
  final int id;
  final String title;
  final String subtitle;
  final int passedCount;
  final String? imageUrl;
  final bool isCompleted;
  final DateTime createdAt;

  const Poll({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.passedCount,
    this.imageUrl,
    this.isCompleted = false,
    required this.createdAt,
  });
}
