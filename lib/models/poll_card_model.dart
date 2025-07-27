class PollCardModel {
  final int id;
  final String? imageUrl;
  final String timestamp;
  final String title;
  final String subtitle;
  final int passedCount;
  final PollStatus status;

  PollCardModel({
    required this.id,
    this.imageUrl,
    required this.timestamp,
    required this.title,
    required this.subtitle,
    required this.passedCount,
    required this.status,
  });

  factory PollCardModel.fromJson(Map<String, dynamic> json, PollStatus status) {
    return PollCardModel(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String?,
      timestamp: json['timestamp'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      passedCount: json['passedCount'] ?? 0,
      status: status,
    );
  }
}

enum PollStatus { notPassed, passed, all }
