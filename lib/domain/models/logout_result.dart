class LogoutResult {
  final String message;

  LogoutResult({required this.message});

  factory LogoutResult.fromJson(Map<String, dynamic> json) {
    return LogoutResult(message: json['message']);
  }
}
