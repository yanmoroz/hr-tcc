enum UserRole { admin, employee }

class CurrentUser {
  final int id;
  final String username;
  final UserRole role;

  const CurrentUser({
    required this.id,
    required this.username,
    required this.role,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      id: json['id'],
      username: json['username'],
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'role': role.name,
  };
}
