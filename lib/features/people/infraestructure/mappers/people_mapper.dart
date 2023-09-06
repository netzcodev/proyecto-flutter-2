import 'package:cars_app/features/people/domain/domain.dart';

class PeopleMapper {
  static jsonToEntity(Map<String, dynamic> json) => People(
        id: json['id'],
        document: json['document'],
        name: json['name'],
        lastName: json['lastName'],
        phone: json['phone'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );
}
