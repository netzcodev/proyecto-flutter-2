import 'package:cars_app/features/permissions/domain/domain.dart';

class PermissionPartialMapper {
  static List<PermissionPartial> permissionPartialJsonToEntity(
      List<dynamic> json) {
    List<PermissionPartial> list = [];

    for (var e in json) {
      list.add(
        PermissionPartial(
          menuName: e['menuName'],
          add: e['add'],
          read: e['read'],
          remove: e['remove'],
          modify: e['modify'],
        ),
      );
    }

    return list;
  }
}
