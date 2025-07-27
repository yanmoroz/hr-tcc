class ChatFileModel {
  final String? fileName;
  final int? fileSizeBytes;
  final String filesUrl;

  const ChatFileModel({
    this.fileName,
    this.fileSizeBytes,
    required this.filesUrl,
  });

  factory ChatFileModel.fromJson(Map<String, dynamic> json) {
    return ChatFileModel(
      fileName: json['filesName'] as String?,
      fileSizeBytes: json['filesSizeBytes'] as int?,
      filesUrl: json['filesUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filesName': fileName,
      'filesSizeBytes': fileSizeBytes,
      'filesUrl': filesUrl,
    };
  }

  ChatFileModel copyWith({
    String? filesName,
    int? filesSizeBytes,
    String? filesUrl,
  }) {
    return ChatFileModel(
      fileName: filesName ?? fileName,
      fileSizeBytes: filesSizeBytes ?? fileSizeBytes,
      filesUrl: filesUrl ?? this.filesUrl,
    );
  }
}
