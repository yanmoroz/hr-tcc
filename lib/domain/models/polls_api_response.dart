class PollsApiResponse {
  final List<Map<String, dynamic>> notPassedRaw;
  final List<Map<String, dynamic>> passedRaw;
  final int notPassedTotal;
  final int passedTotal;

  PollsApiResponse({
    required this.notPassedRaw,
    required this.passedRaw,
    required this.notPassedTotal,
    required this.passedTotal,
  });

  factory PollsApiResponse.fromJson(Map<String, dynamic> json) {
    return PollsApiResponse(
      notPassedRaw: List<Map<String, dynamic>>.from(
        json['not_finished_polls'] ?? [],
      ),
      passedRaw: List<Map<String, dynamic>>.from(json['finished_polls'] ?? []),
      notPassedTotal: _parseInt(json['not_finished_polls_total_count']),
      passedTotal: _parseInt(json['finished_polls_total_count']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
