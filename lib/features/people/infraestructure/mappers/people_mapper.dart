import 'package:cars_app/features/people/domain/domain.dart';

class PeopleMapper {
  static jsonToEntity(Map<String, dynamic> json) => People(
        id: json['id'],
        document: json['document'] ?? 0,
        name: json['name'],
        lastName: json['lastName'],
        phone: json['phone'] ?? '',
        email: json['email'],
        photo: json['photo'] ?? '',
        status: json['status'],
        userId: json['userId'],
        password: json['password'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );
}
