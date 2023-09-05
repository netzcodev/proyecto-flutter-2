class User {
  final int id;
  final String email;
  final String fullName;
  final String role;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.token,
  });

  bool get isAdmin {
    return role == 'admin';
  }
}
