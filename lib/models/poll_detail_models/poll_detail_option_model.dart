// Модель для создания модального силектора

class PollDetailOptionModel {
  final String id;
  final String? title;
  final String? subTitle;
  final String? imageUrl;

  const PollDetailOptionModel({
    required this.id,
    this.title,
    this.subTitle,
    this.imageUrl,
  });

  factory PollDetailOptionModel.fromJson(Map<String, dynamic> json) =>
      PollDetailOptionModel(
        id: json['id'] as String,
        title: json['title'] as String?,
        subTitle: json['subTitle'] as String?,
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subTitle': subTitle,
        'imageUrl': imageUrl,
      };
}