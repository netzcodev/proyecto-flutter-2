import 'package:cars_app/features/users/domanin/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        fullName: json['fullName'],
        role: json['role'],
        token: json['token'],
      );
}
