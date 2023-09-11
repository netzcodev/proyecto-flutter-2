import 'package:cars_app/features/permissions/domain/domain.dart';

class User {
  final int id;
  final String email;
  final String fullName;
  final String role;
  final String token;
  final List<PermissionPartial>? menu;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.token,
    this.menu,
  });

  bool get isAdmin {
    return role == 'admin';
  }

  bool get isCustomer {
    return role == 'cliente';
  }
}
