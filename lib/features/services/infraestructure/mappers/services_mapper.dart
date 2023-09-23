import 'package:cars_app/features/services/domain/domain.dart';

class ServiceMapper {
  static jsonToEntity(Map<String, dynamic> json) => Service(
        id: json['id'],
        serviceTypeId: json['serviceTypeId'],
        currentDate: json['currentDate'],
        comingDate: json['comingDate'] ?? '',
        duration: json['duration'],
        updatedAt: json['updatedAt'],
        createdAt: json['createdAt'],
        name: json['name'],
        description: json['description'],
      );

  static List<Service> jsonToListEntity(List<dynamic> json) {
    List<Service> bagList = [];

    for (var element in json) {
      bagList.add(jsonToEntity(element));
    }

    return bagList;
  }
}
