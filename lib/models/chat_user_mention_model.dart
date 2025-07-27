class ChatUserMentionModel {
  final String id;
  final String name;
  final String? avatarLink;
  final String initials;
  ChatUserMentionModel({
    required this.id,
    required this.name,
    this.avatarLink,
    required this.initials,
  });
}