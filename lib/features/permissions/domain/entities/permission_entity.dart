// Generated by https://quicktype.io
import 'package:cars_app/features/menu/menu.dart';

class Permission {
  final int id;
  final int roleId;
  final int menuId;
  final int add;
  final int read;
  final int modify;
  final int remove;
  final String? createdAt;
  final String? updatedAt;
  final List<Menu>? menu;

  Permission({
    required this.id,
    required this.roleId,
    required this.menuId,
    required this.add,
    required this.read,
    required this.modify,
    required this.remove,
    this.createdAt,
    this.updatedAt,
    this.menu,
  });
}